# frozen_string_literal: true

require 'sequel'

DB = Sequel.sqlite

target_dirs = Memo::Config.target_dirs

# 対象ディレクトリの一覧を作成する
absolute_paths = target_dirs.flat_map do |root_dir|
  [root_dir].concat(
    Dir.glob('**/*/', base: root_dir).map do |rel_path|
      File.join(root_dir, rel_path)
    end
  )
end

DB.create_table :directories do
  primary_key :id
  String :absolute_path
end

absolute_paths.map do |path|
  DB[:directories].insert(absolute_path: path)
end

directories = DB[:directories]

directories.all

DB.create_table :target_files do
  primary_key :id
  String :absolute_path
  foreign_key :parent_directory_id, :directories
  String :file_content
end

target_dirs.flat_map do |root_dir|
  Dir.glob('**/*.md', base: root_dir).filter_map do |rel_path|
    next if ['README.md'].include?(File.basename(rel_path))

    absolute_path = File.join(root_dir, rel_path)
    parent_dir = File.dirname(absolute_path) << '/'
    file_content = File.readlines(absolute_path).join("\n")

    parent_directory_id = DB[:directories].where(absolute_path: parent_dir).map(:id)[0]

    DB[:target_files].insert(
      absolute_path: absolute_path,
      parent_directory_id: parent_directory_id,
      file_content: file_content
    )
  end
end

target_files = DB[:target_files]

target_files.all
