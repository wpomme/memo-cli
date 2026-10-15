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
        def seeds(config_directory_seeds_result)
          insert_all(config_directory_seeds_result)
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<String, Integer>] パス名がキーで、主キーが値となるハッシュを返す
        def insert_all(config_directory_seeds_result)
          Memo::Database::Service.rel_paths_hash.each_with_object({}) do |(target_dir, rel_paths), result|
            rel_paths.flat_map do |rel_path|
              directory_id = @dataset.insert(
                config_directory_id: config_directory_seeds_result[target_dir],
                directory_path: rel_path
              )
              result[rel_path] = directory_id
            end
          end
        end
      end
    end
  end
end
