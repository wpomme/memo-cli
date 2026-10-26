# frozen_string_literal: true

module Memo
  module View
    class Tag
      def self.run(word)
        new.execute(word)
      end

      def initialize
        @file_loader = Memo::FileLoader.new
      end

      def execute(word)
        tag_list = @file_loader.sorted_tags
        tag_files_hash = @file_loader.tag_files_hash

        return str_array_to_view(word, tag_files_hash[word], TAG_COLOR) if tag_list.include?(word)

        Message::NO_TAGS.sub('tag', word) << tag_list.join(SPACE)
      end

      private

      # 与えられた文字列と、文字列型の配列に従って、ユーザーに表示するための配列を作成する
      #
      # @return [Array<String>]
      def str_array_to_view(str, arr, color_symbol)
        return [] if arr.nil?

        [Rainbow(str).color(color_symbol)] << arr.join(SPACE)
      end
    end
  end
end
