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
        # @return [Array<Integer>] 挿入したデータのIDの配列を返す
        def seeds
          insert_all
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Array<Integer>] 挿入したデータのIDの配列を返す
        def insert_all
          Memo::Database::Service.absolute_paths.map do |path|
            @dataset.insert(absolute_path: path)
          end
        end
      end
    end
  end
end
