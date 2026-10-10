# frozen_string_literal: true

module Memo
  module DB
    module Controller
      class Directory
        def initialize(db)
          @db = db
        end

        # 対象のデータをテーブルに一括して保存するためのメソッド
        # TODO: Modelを使ってデータを挿入したい
        # NOTE: Modelにはvalidateする機能があり、同じデータの挿入を防ぐことができる
        def set_up
          Memo::DB::Service.absolute_paths.each do |absolute_path|
            @db[:directories].insert(absolute_path: absolute_path)
          end
        end
      end
    end
  end
end
