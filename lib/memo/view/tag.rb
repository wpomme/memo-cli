# frozen_string_literal: true

module Memo
  module View
    class Tag
      def run(word:)
        puts Memo::ViewModel::Tag.new.run(word)
      end
    end
  end
end
