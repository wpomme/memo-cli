# frozen_string_literal: true

require 'sequel'

# database_path = File.join(Dir.pwd, 'db/production_memo.db')
database_path = File.join(Dir.pwd, 'db/test_memo.db')
FileUtils.touch(database_path) unless FileTest.file?(database_path)
DB = Sequel.sqlite(database_path)

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

# 2. Filesテーブルを作成する
DB.create_table :files do
  primary_key :id
  String :absolute_path
  foreign_key :parent_directory_id, :directories
  String :file_content
end

file_tag_hash = {}

target_dirs.flat_map do |root_dir|
  Dir.glob('**/*.md', base: root_dir).filter_map do |rel_path|
    next if ['README.md'].include?(File.basename(rel_path))

    absolute_path = File.join(root_dir, rel_path)
    parent_dir = File.dirname(absolute_path) << '/'
    file_content = File.readlines(absolute_path).join("\n")

    parent_directory_id = DB[:directories].where(absolute_path: parent_dir).map(:id)[0]

    front_matter = Memo::Service.parse_yaml_front_matter(file_content)

    tags = front_matter['tags'].nil? ? [] : front_matter['tags']

    files_id = DB[:files].insert(
      absolute_path: absolute_path,
      parent_directory_id: parent_directory_id,
      file_content: file_content
    )

    file_tag_hash[files_id] = tags
  end
end

# 3. Tagsテーブルを作成する
DB.create_table :tags do
  primary_key :id
  String :tag_name
end

tags = file_tag_hash.values.flatten.sort.uniq
# mapにするとプライマリーキーの配列が返ってくる
tags.each do |tag|
  DB[:tags].insert(tag_name: tag)
end

# 4. FilesTagsテーブルを作成する
DB.create_table :files_tags do
  primary_key :id
  foreign_key :files_id, :files
  foreign_key :tags_id, :tags
end

tag_id_hash = DB[:tags].all.to_h do |hash|
  [hash[:tag_name], hash[:id]]
end

file_tag_ids = file_tag_hash.dup

file_tag_id_hash = file_tag_ids.transform_values do |tags|
  tags.map do |tag|
    tag_id_hash[tag]
  end
end

file_tag_id_hash.each do |files_id, tags_ids|
  tags_ids.each do |tags_id|
    DB[:files_tags].insert(
      files_id: files_id,
      tags_id: tags_id
    )
  end
end

### その他、集計や削除のためのコマンド
# 集計
DB[:files].count

# データを全て削除
DB[:files].delete # => 削除した列の数が返り値
## 同時にハッシュも削除しておく
file_tag_hash.clear
