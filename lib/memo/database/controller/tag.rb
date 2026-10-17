# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class Tag
        extend Forwardable

        attr_reader :dataset

        def_delegators :@dataset, :all, :delete

        def initialize(db)
          @dataset = db[:tags]
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

        # テーブルのデータを全件取得する。数百件程度のデータであるため、全件取得する
        #
        # 戻り値は一次元配列の中にハッシュが入っている
        # @return [Array<Hash<symbol, <Integer | String>>>]
        # delegate all: :@dataset

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<String, Integer>] タグ名がキーで、主キーが値となるハッシュを返す
        def insert_all
          file_loader = Memo::Loader::FileLoader.new

          file_loader.sorted_tags.each_with_object({}) do |tag, result|
            tag_id = @dataset.insert(tag_name: tag)
            result[tag] = tag_id
          end
        end
      end
    end
  end
end
