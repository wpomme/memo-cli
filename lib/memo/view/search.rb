# frozen_string_literal: true

module Memo
  module View
    class Search
      def execute(word:)
        puts Memo::ViewModel::Search.new.execute(word)
      end
    end
  end
end
