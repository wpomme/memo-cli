# frozen_string_literal: true

module Memo
  module ViewModel
    class Read
      include Memo::Message
      include Memo::Service

      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      def execute(word)
        @word = normalize(word)

        found = find_files
        show_files_by_found_size(found)
      end

      private

      # 見つかったファイルの数によって表示する文字列を変える
      def show_files_by_found_size(found)
        size = found.size

        case size
        when 0
          NO_MEMOS_WEWE_FOUND.sub('word', @word) if size.zero?
        when 1
          found[0][:file_content] if size == 1
        else
          read_prompt(found)
        end
      end

      def read_prompt(found)
        choices = found.to_h { |file_seed| [file_seed[:parent_directory], file_seed] }
        choice = select_prompt(title: MULTIPLE_MEMOS_WEWE_FOUND.sub('size', found.size.to_s), choices: choices)
        choice.values.flatten
      end

      # 検索文字列と合致するファイル名を検索し、見つけたらFileSeedの配列を返す
      #
      # @return [Array]
      def find_files
        @file_loader.file_seeds.filter do |file_seed|
          file_seed[:filename] == @word
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
