# frozen_string_literal: true

module Memo
  module View
    INDENT = ' '

    class Tag
      def self.run(word)
        new(word).execute
      end

      def initialize(word)
        @word = word
        @file_loader = Memo::Loader::FileLoader.new
      end

      def execute
        tag_list = @file_loader.sorted_tags
        tag_files_hash = @file_loader.tag_files_hash

        return seeds_key_to_view(tag_files_hash[@word], @word, :aqua) if tag_list.include?(@word)

        Message::NO_TAGS.sub('tag', @word) << tag_list.join(INDENT)
      end

      private

      # TODO: Strategyに移動する
      def seeds_key_to_view(files, key, color_symbol)
        return [] if files.nil?

        [Rainbow(key).color(color_symbol)] << files.join(INDENT)
      end
    end
  end
end
