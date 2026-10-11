# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class Directory
        # 対象のデータをテーブルに一括して保存するためのメソッド
        def setup
          directory = Memo::Database::Model::Directory.new

          Memo::Database::Service.absolute_paths.each do |absolute_path|
            directory.set(absolute_path: absolute_path)
          end
        end
      end
    end
  end
end
