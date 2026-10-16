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
        def seeds(directory_seeds_result)
          insert_all(directory_seeds_result)
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<Integer, String>] Fileテーブルの主キーと、対象のファイルの絶対パスが対となるハッシュを返す
        def insert_all(directory_seeds_result)
          file_loader = Memo::Database::FileLoader.new
          file_seeds_hash = file_loader.file_seeds_hash

          path_to_id = Memo::Database::Controller::ConfigDirectory.new.path_to_id

          # Controller#Directoryと共通
          duplicated_rel_path = ''

          file_seeds_hash.each_with_object({}) do |(target_dir, file_hash_array), result|
            file_hash_array.flat_map do |file_hash|
              absolute_path = file_hash[:absolute_path]
              rel_path = file_hash[:parent_directory]
              parent_directory_id_or_hash = directory_seeds_result[rel_path]

              parent_directory_id = rel_path == duplicated_rel_path ? parent_directory_id_or_hash[target_dir] : parent_directory_id_or_hash

              file_id = @dataset.insert(
                filename: file_hash[:filename],
                config_directory_id: path_to_id[target_dir],
                parent_directory_id: parent_directory_id,
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
