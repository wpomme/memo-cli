# frozen_string_literal: true

module Memo
  module DB
    module Controller
      class Directory
        # 対象のデータをテーブルに一括して保存するためのメソッド
        def set_up
          directory = Memo::Database::Models.Directory.new

          Memo::Database::Service.absolute_paths.each do |absolute_path|
            directory.create(absolute_path: absolute_path)
          end
        end
      end
    end
  end
end
