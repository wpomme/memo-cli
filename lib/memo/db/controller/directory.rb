# frozen_string_literal: true

module Memo
  module DB
    module Controller
      class Directory
        def initialize(db)
          @db = db
        end

        # 対象のデータをテーブルに一括して保存するためのメソッド
        def set_up
          Memo::DB::Models.directory(@db)

          Memo::DB::Service.absolute_paths.each do |absolute_path|
            Memo::DB::Models::Directory.create(absolute_path: absolute_path)
          end
        end
      end
    end
  end
end
