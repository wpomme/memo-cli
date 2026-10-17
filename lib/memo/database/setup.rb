# frozen_string_literal: true

module Memo
  module Database
    TABLE_NAMES = %i[config_directories directories files tags files_tags].freeze

    module Setup
      class << self
        def execute
          drop_tables_if_exist
          create_tables
          seeds
        end

        # テーブルだけ作成するメソッド
        def prepare
          drop_tables_if_exist
          create_tables
        end

        # テーブルを作成する順番と逆に削除する
        def drop_tables_if_exist
          TABLE_NAMES.reverse.each do |table_name|
            DB.drop_table(table_name) if DB.table_exists?(table_name)
          end
        end

        def create_tables
          TABLE_NAMES.map do |table_name|
            DB.create_table table_name, &to_schema(table_name)
          end
        end

        def seeds
          # NOTE: まとめられそう
          config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
          directory_dataset = Memo::Database::Controller::Directory.new
          file_dataset = Memo::Database::Controller::File.new
          tag_dataset = Memo::Database::Controller::Tag.new
          file_tag_dataset = Memo::Database::Controller::FileTag.new

          config_directory_dataset.seeds
          directory_dataset.seeds
          file_dataset.seeds
          tag_dataset.seeds
          file_tag_dataset.seeds
        end

        def to_schema(table_symbol)
          {
            config_directories: proc do
              primary_key :id
              String :directory_path
            end,
            directories: proc do
              primary_key :id
              foreign_key :config_directory_id, :config_directories
              String :directory_path
            end,
            files: proc do
              primary_key :id
              String :filename
              foreign_key :config_directory_id, :config_directories
              foreign_key :parent_directory_id, :directories
              String :file_content
            end,
            tags: proc do
              primary_key :id
              String :tag_name
            end,
            files_tags: proc do
              primary_key :id
              foreign_key :files_id, :files
              foreign_key :tags_id, :tags
            end
          }[table_symbol]
        end
      end

      private_class_method :drop_tables_if_exist, :create_tables, :seeds, :to_schema
    end
  end
end
