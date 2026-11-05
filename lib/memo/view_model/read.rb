# frozen_string_literal: true

module Memo
  module ViewModel
    class Read
      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      def execute(word)
        normalized = normalize(word)
        find_files(normalized)
      end

      private

      # 検索でヒットした文字列に色をつける
      #
      # @param word [string]
      # @return [Array]
      def find_files(word)
        @file_loader.file_seeds.filter do |file_seed|
          file_seed[:filename] == word
        end
      end

      # 検索文字列の名寄せを行う
      # ディレクトリであれば、ファイル名にする
      # また、拡張子が付いていれば、取り除く
      #
      # @return [String]
      def normalize(word)
        File.basename(word, '.md')
      end
    end
  end
end
