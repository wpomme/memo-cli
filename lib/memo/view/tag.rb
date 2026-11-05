# frozen_string_literal: true

module Memo
  module View
    class Tag
      def execute(word:)
        puts Memo::ViewModel::Tag.new.execute(word)
      end
    end
  end
end
