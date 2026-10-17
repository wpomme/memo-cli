# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class File
        extend Forwardable

        attr_reader :dataset

        def_delegators :@dataset, :all, :delete

        def initialize
          @dataset = Memo::Database.db[:files]
        end

        # ファイルテーブルのIDがキーで、対象ファイルの絶対パスが値となるハッシュを返す
        #
        # @return [Hash<Integer, String>]
        def id_to_absolute_filename
          absolute_filenames
            .to_h do |row|
              [row[:file_id], row[:absolute_path]]
            end
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<Integer, String>] Fileテーブルの主キーと、対象のファイルの絶対パスが対となるハッシュを返す
        def seeds
          insert_all
        end

        private

        def absolute_filenames
          @dataset
            .join(:directories, id: :parent_directory_id)
            .join(:config_directories, id: Sequel[:directories][:config_directory_id])
            .select(
              Sequel.join(
                [Sequel[:config_directories][:directory_path],
                 Sequel[:directories][:directory_path],
                 Sequel[:files][:filename],
                 '.md']
              ).as(:absolute_path),
              Sequel[:files][:id].as(:file_id)
            )
        end

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<Integer, String>] Fileテーブルの主キーと、対象のファイルの絶対パスが対となるハッシュを返す
        def insert_all
          path_to_id = Memo::Database::Controller::ConfigDirectory.new.path_to_id
          absolute_directory_path_to_id = Memo::Database::Controller::Directory.new.absolute_directory_path_to_id

          Memo::Loader::FileLoader.new.file_seeds_hash.flat_map do |target_dir, file_hash_array|
            file_hash_array.flat_map do |file_hash|
              @dataset.insert(
                filename: file_hash[:filename],
                config_directory_id: path_to_id[target_dir],
                parent_directory_id: absolute_directory_path_to_id[file_hash[:parent_directory]],
                file_content: file_hash[:file_content]
              )
            end
          end
        end
      end
    end
  end
end
