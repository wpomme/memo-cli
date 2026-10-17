# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class Directory
        def initialize
          @dataset = DB[:directories]
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<String, Integer>] パス名がキーで、主キーが値となるハッシュを返す
        def seeds
          insert_all
        end

        # ディレクトリの絶対パスがキーで、ディレクトリテーブルのIDが値となるハッシュを返す
        #
        # @return [Hash<String, Integer>]
        def absolute_directory_path_to_id
          absolute_directory_paths
            .to_h do |row|
              [row[:absolute_path], row[:directory_id]]
            end
        end

        private

        # ディレクトリの絶対パスと設定ディレクトリのIDのオブジェクトを配列で返す
        #
        # @return [Array<Hash>]
        def absolute_directory_paths
          @dataset
            .join(:config_directories, id: :config_directory_id)
            .select(
              Sequel.join(
                [Sequel[:config_directories][:directory_path],
                 Sequel[:directories][:directory_path]]
              ).as(:absolute_path),
              Sequel[:directories][:id].as(:directory_id)
            )
        end

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Array<Integer>] 挿入したレコードのIDを配列で返す
        def insert_all
          path_to_id = Memo::Database::Controller::ConfigDirectory.new.path_to_id

          Memo::Loader::DirectoryLoader.rel_paths_hash.flat_map do |target_dir, rel_paths|
            rel_paths.flat_map do |rel_path|
              @dataset.insert(
                config_directory_id: path_to_id[target_dir],
                directory_path: rel_path
              )
            end
          end
        end
      end
    end
  end
end
