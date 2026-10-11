# frozen_string_literal: true

module Memo
  module Database
    TABLE_NAMES = %i[directories files tags files_tags].freeze

    module Setup
      class << self
        def execute
          drop_tables_if_exist
          create_tables
        end

        def create_tables
          TABLE_NAMES.map do |table_name|
            DB.create_table table_name, &to_schema(table_name)
          end
        end

        # TODO: Controllerのseedsを使って、全てのデータを挿入する
        # test_file_tag.rbのテストケースを参考にしてコードを作成すること
        # def seeds
        # end

        # 既にテーブルがあれば、そのテーブルを削除する
        # 外部キー制約があるため、テーブルを作成する順番と逆に削除する
        def drop_tables_if_exist
          TABLE_NAMES.reverse.each do |table_name|
            DB.drop_table(table_name) if DB.table_exists?(table_name)
          end
        end

        def to_schema(table_symbol)
          {
            directories: proc do
              primary_key :id
              String :absolute_path
            end,
            files: proc do
              primary_key :id
              String :absolute_path
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

      private_class_method :create_tables, :drop_tables_if_exist, :to_schema
    end
  end
end
