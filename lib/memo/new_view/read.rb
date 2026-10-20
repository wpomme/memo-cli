# frozen_string_literal: true

module Memo
  module NewView
    class Read
      def self.run(word)
        new(word).execute
      end

      def initialize(word)
        @word = word
      end

      def execute
        unified = unify_word(@word)

        find_files(unified)
      end

      private

      # 検索でヒットした文字列に色をつける
      #
      # @param word [string]
      # @return [Array]
      def find_files(word)
        Memo::Loader::FileLoader.new.file_seeds_to_search.flat_map do |_, file_hash_array|
          file_hash_array.filter do |file_hash|
            file_hash[:filename] == word
          end
        end
      end

      # 検索文字列の名寄せを行う
      # ディレクトリであれば、ファイル名にする
      # また、拡張子が付いていれば、取り除く
      #
      # @return [String]
      def unify_word(word)
        File.basename(word, '.md')
      end
    end
  end
end
