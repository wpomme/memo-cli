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
        def seeds
          insert_all
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<Integer, String>] Fileテーブルの主キーと、対象のファイルの絶対パスが対となるハッシュを返す
        def insert_all
          file_loader = Memo::Database::FileLoader.new
          file_hash_seeds = file_loader.file_hash_seeds

          directory_dataset = DB[:directories]

          file_hash_seeds.each_with_object({}) do |file_hash, result|
            parent_directory_id = directory_dataset.where(absolute_path: file_hash[:parent_directory]).map(:id)[0]
            absolute_path = file_hash[:absolute_path]

            file_id = @dataset.insert(
              absolute_path: absolute_path,
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
