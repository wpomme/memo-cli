# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class File
        def initialize
          @dataset = DB[:files]
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<Integer, String>] Fileテーブルの主キーと、対象のファイルの絶対パスが対となるハッシュを返す
        def seeds(config_directory_seeds_result, directory_seeds_result)
          insert_all(config_directory_seeds_result, directory_seeds_result)
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<Integer, String>] Fileテーブルの主キーと、対象のファイルの絶対パスが対となるハッシュを返す
        def insert_all(config_directory_seeds_result, directory_seeds_result)
          file_loader = Memo::Database::FileLoader.new
          file_seeds_hash = file_loader.file_seeds_hash

          file_seeds_hash.each_with_object({}) do |(target_dir, file_hash_array), result|
            file_hash_array.flat_map do |file_hash|
              absolute_path = file_hash[:absolute_path]

              file_id = @dataset.insert(
                filename: file_hash[:filename],
                config_directory_id: config_directory_seeds_result[target_dir],
                parent_directory_id: directory_seeds_result[file_hash[:parent_directory]],
                file_content: file_hash[:file_content]
              )
              result[file_id] = absolute_path
            end
          end
        end
      end
    end
  end
end
