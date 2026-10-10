# frozen_string_literal: true

module Memo
  module DB
    TABLE_NAMES = %i[directories files tags files_tags].freeze

    module SetUp
      class << self
        def execute(database_path)
          db = Connection.execute(database_path)

          create_tables(db)
        end

        # 該当のデータベースについて、指定したテーブルが作成されていなければ、そのテーブルを作成する
        def create_tables(db)
          TABLE_NAMES.map do |table_name|
            db.create_table table_name, &to_scheme(table_name) unless db.table_exists?(table_name)
          end
        end

        def to_scheme(table_symbol)
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
              foreign_key :target_files_id, :files
              foreign_key :tags_id, :tags
            end
          }[table_symbol]
        end
      end

      private_class_method :create_tables, :to_scheme
    end
  end
end
