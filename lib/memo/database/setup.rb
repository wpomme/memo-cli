# frozen_string_literal: true

module Memo
  module Database
    TABLE_NAMES = %i[config_directories directories files tags files_tags].freeze
    CONTROLLER_NAMES = %w[ConfigDirectory Directory File Tag FileTag].freeze

    def self.db(database_path: Memo::Config.target_database)
      @db ||= Memo::Database::Prepare.execute(database_path: database_path)
    end

    class Setup
      def initialize(db)
        @db = db
      end

      def execute
        prepare
        seeds
      end

      # テーブルだけ作成するメソッド
      def prepare
        drop_tables_if_exist
        create_tables
      end

      private

      # テーブルを作成する順番と逆に削除する
      def drop_tables_if_exist
        TABLE_NAMES.reverse.each do |table_name|
          @db.drop_table(table_name) if @db.table_exists?(table_name)
        end
      end

      def create_tables
        TABLE_NAMES.map do |table_name|
          @db.create_table table_name, &to_schema(table_name)
        end
      end

      def seeds
        CONTROLLER_NAMES.each do |name|
          klass = Object.const_get("Memo::Database::Controller::#{name}")
          klass.new.seeds
        end
      end

      def to_schema(table_symbol)
        {
          config_directories: proc do
            primary_key :id
            String :directory_path, null: false
          end,
          directories: proc do
            primary_key :id
            foreign_key :config_directory_id, :config_directories, null: false
            String :directory_path, null: false
          end,
          files: proc do
            primary_key :id
            String :filename, null: false
            foreign_key :config_directory_id, :config_directories, null: false
            foreign_key :parent_directory_id, :directories, null: false
            String :file_content, null: false
          end,
          tags: proc do
            primary_key :id
            String :tag_name, null: false, unique: true
          end,
          files_tags: proc do
            primary_key :id
            foreign_key :files_id, :files, null: false
            foreign_key :tags_id, :tags, null: false
          end
        }[table_symbol]
      end
    end
  end
end
