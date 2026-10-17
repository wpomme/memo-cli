# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class Tag
        extend Forwardable

        attr_reader :dataset

        def_delegators :@dataset, :all, :delete

        def initialize
          @dataset = Memo::Database.db[:tags]
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<String, Integer>] タグ名がキーで、主キーが値となるハッシュを返す
        def seeds
          insert_all
        end

        def tag_to_id
          all.to_h do |row|
            [row[:tag_name], row[:id]]
          end
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<String, Integer>] タグ名がキーで、主キーが値となるハッシュを返す
        def insert_all
          Memo::Loader::FileLoader.new.sorted_tags.each_with_object({}) do |tag, result|
            tag_id = @dataset.insert(tag_name: tag)
            result[tag] = tag_id
          end
        end
      end
    end
  end
end
