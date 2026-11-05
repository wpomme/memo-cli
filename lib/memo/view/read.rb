# frozen_string_literal: true

module Memo
  module View
    class Read
      include Memo::Message
      include Memo::Service

      def execute(word:)
        puts read_file_by_found_result(word)
      end

      private

      def read_file_by_found_result(word)
        found = Memo::ViewModel::Read.new.execute(word)
        size = found.size

        return NO_MEMOS_WEWE_FOUND.sub('word', word) if size.zero?

        return found[0][:file_content] if size == 1

        read_prompt(found)
      end

      def read_prompt(found)
        choices = found.to_h { |file_seed| [file_seed[:parent_directory], file_seed] }
        choice = select_prompt(title: MULTIPLE_MEMOS_WEWE_FOUND.sub('size', found.size.to_s), choices: choices)
        choice.values.flatten
      end
    end
  end
end
