# frozen_string_literal: true

module Memo
  module ViewModel
    class Tag
      include Memo::ViewModel
      include Memo::Message

      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      def execute(word)
        tag_files = @file_loader.tag_files_hash[word]

        return tag_to_view(word, tag_files) unless tag_files.nil?

        NO_TAGS.sub('tag', word) << @file_loader.tags_sorted_by_tag_name.join(SPACE)
      end

      private

      # 与えられた文字列と、文字列型の配列に従って、ユーザーに表示するための配列を作成する
      #
      # @return [Array<String>]
      def tag_to_view(word, files)
        tag_and_size = tag_color("#{word}: #{files.size}")
        "#{tag_and_size}\n#{files.join(SPACE)}"
      end
    end
  end
end
