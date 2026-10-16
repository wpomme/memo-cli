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

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<String, Integer>] パス名がキーで、主キーが値となるハッシュを返す
        def insert_all
          # NOTE: 対象ディレクトリごとに同じ名前のディレクトリが作成される可能性がある
          # その場合は、DirectoryLoaderで検知するのが適切と思われる
          duplicated_rel_path = ''
          duplicated_path_hash = {}

          path_to_id = Memo::Database::Controller::ConfigDirectory.new.path_to_id

          result = Memo::Database::Service.rel_paths_hash.each_with_object({}) do |(target_dir, rel_paths), result|
            result = rel_paths.flat_map do |rel_path|
              directory_id = @dataset.insert(
                config_directory_id: path_to_id[target_dir],
                directory_path: rel_path
              )
              duplicated_path_hash[target_dir] = directory_id if rel_path == duplicated_rel_path
              result[rel_path] = directory_id
            end
          end

          result[duplicated_rel_path] = duplicated_path_hash

          result
        end
      end
    end
  end
end
