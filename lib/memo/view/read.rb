# frozen_string_literal: true

module Memo
  module View
    class Read
      def self.run(word)
        new(word).execute
      end

      def initialize(word)
        @word = normalize(word)
      end

      def execute
        find_files(@word)
      end

      private

      # 検索でヒットした文字列に色をつける
      #
      # @param word [string]
      # @return [Array]
      def find_files(word)
        Memo::FileLoader.new.file_seeds.filter do |file_seed|
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
