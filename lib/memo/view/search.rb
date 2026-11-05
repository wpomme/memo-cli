# frozen_string_literal: true

module Memo
  module View
    class Search
      def run(word:)
        puts Memo::ViewModel::Search.new.run(word)
      end
    end
  end
end
