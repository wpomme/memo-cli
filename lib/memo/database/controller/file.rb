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
        # @return [Array<Integer>] 挿入したデータのIDの配列を返す
        def seeds
          insert_all
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Array<Integer>] 挿入したデータのIDの配列を返す
        def insert_all
          file_loader = Memo::Database::FileLoader.new
          file_hash_seeds = file_loader.file_hash_seeds

          directory_dataset = DB[:directories]

          file_hash_seeds.map do |file_hash|
            parent_directory_id = directory_dataset.where(absolute_path: file_hash[:parent_directory]).map(:id)[0]

            @dataset.insert(
              absolute_path: file_hash[:absolute_path],
              parent_directory_id: parent_directory_id,
              file_content: file_hash[:file_content]
            )
          end
        end
      end
    end
  end
end
