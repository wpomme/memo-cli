# frozen_string_literal: true

require 'sequel'

db_path = File.join(Dir.pwd, 'db/memo.db')
DB = Sequel.sqlite(db_path)

target_dirs = Memo::Config.target_dirs

# 1. Directoriesテーブルを作成する
DB.create_table :directories do
  primary_key :id
  String :absolute_path
end

# 対象ディレクトリの一覧を作成する
absolute_paths = target_dirs.flat_map do |root_dir|
  [root_dir].concat(
    Dir.glob('**/*/', base: root_dir).map do |rel_path|
      File.join(root_dir, rel_path)
    end
  )
end

absolute_paths.map do |path|
  DB[:directories].insert(absolute_path: path)
end

# 2. Target_filesテーブルを作成する
DB.create_table :target_files do
  primary_key :id
  String :absolute_path
  foreign_key :parent_directory_id, :directories
  String :file_content
end

target_files_tags_hash = {}

target_dirs.flat_map do |root_dir|
  Dir.glob('**/*.md', base: root_dir).filter_map do |rel_path|
    next if ['README.md'].include?(File.basename(rel_path))

    absolute_path = File.join(root_dir, rel_path)
    parent_dir = File.dirname(absolute_path) << '/'
    file_content = File.readlines(absolute_path).join("\n")

    parent_directory_id = DB[:directories].where(absolute_path: parent_dir).map(:id)[0]

    front_matter = Memo::Service.parse_yaml_front_matter(file_content)

    tags = front_matter['tags'].nil? ? [] : front_matter['tags']

    target_files_id = DB[:target_files].insert(
      absolute_path: absolute_path,
      parent_directory_id: parent_directory_id,
      file_content: file_content
    )

    target_files_tags_hash[target_files_id] = tags
  end
end

# 3. Tagsテーブルを作成する
DB.create_table :tags do
  primary_key :id
  String :tag_name
end

tags = target_files_tags_hash.values.flatten.sort.uniq
# mapにするとプライマリーキーの配列が返ってくる
tags.each do |tag|
  DB[:tags].insert(tag_name: tag)
end

# 4. Target_files_tagsテーブルを作成する
DB.create_table :target_files_tags do
  primary_key :id
  foreign_key :target_files_id, :target_files
  foreign_key :tags_id, :tags
end

tag_id_hash = DB[:tags].all.to_h do |hash|
  [hash[:tag_name], hash[:id]]
end

target_files_tags_ids = target_files_tags_hash.dup

target_files_id_tags_id_hash = target_files_tags_ids.transform_values do |tags|
  tags.map do |tag|
    tag_id_hash[tag]
  end
end

target_files_id_tags_id_hash.each do |target_files_id, tags_ids|
  tags_ids.each do |tags_id|
    DB[:target_files_tags].insert(
      target_files_id: target_files_id,
      tags_id: tags_id
    )
  end
end

### その他、集計や削除のためのコマンド
# 集計
DB[:target_files].count

# データを全て削除
DB[:target_files].delete # => 削除した列の数が返り値
## 同時にハッシュも削除しておく
target_files_tags_hash.clear
