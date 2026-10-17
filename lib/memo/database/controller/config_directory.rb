# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class ConfigDirectory
        extend Forwardable

        attr_reader :dataset

        # テーブルのデータを全件取得する。数件しかデータないため、全件取得可能
        #
        # 戻り値は一次元配列の中にハッシュが入っている
        # :id, :directory_pathでハッシュにアクセス可能
        # @return [Array<Hash<symbol, <Integer | String>>>]
        def_delegators :@dataset, :all, :delete

        def initialize
          @dataset = Memo::Database.db[:config_directories]
        end

        # config.ymlに記載のあるディレクトリを保存するテーブルに、データを挿入する
        #
        # @return [Hash<String, Integer>] パス名がキーで、主キーが値となるハッシュを返す
        def seeds
          insert_all
        end

        # 設定ファイルのパスがキー、主キーが値のハッシュを返す
        #
        # @return [Hash<String, Integer>]
        def path_to_id
          @dataset.to_h do |row|
            [row[:directory_path], row[:id]]
          end
        end

        private

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<String, Integer>] パス名がキーで、主キーが値となるハッシュを返す
        def insert_all(target_dirs = Memo::Config.target_dirs)
          target_dirs.map do |path|
            @dataset.insert(directory_path: path)
          end
        end
      end
    end
  end
end
