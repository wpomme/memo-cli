# frozen_string_literal: true

module Memo
  module Controller
    class Directory

      # 対象のデータをテーブルに一括して保存するためのメソッド
      def set_up
        Memo::DB::Service.absolute_paths.each do |absolute_path|
          Memo::DB::Model::Directory.new(absolute_path: absolute_path)
        end
      end
    end
  end
end
