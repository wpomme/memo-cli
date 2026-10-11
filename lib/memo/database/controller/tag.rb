# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class Tag
        def initialize
          @dataset = DB[:tags]
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<String, Integer>] タグ名がキーで、主キーが値となるハッシュを返す
        def seeds
          insert_all
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<String, Integer>] タグ名がキーで、主キーが値となるハッシュを返す
        def insert_all
          file_loader = Memo::Database::FileLoader.new

          file_loader.all_tags.each_with_object({}) do |tag, result|
            tag_id = @dataset.insert(tag_name: tag)
            result[tag] = tag_id
          end
        end
      end
    end
  end
end
