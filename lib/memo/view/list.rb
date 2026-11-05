# frozen_string_literal: true

module Memo
  module View
    class List
      def run(word: '')
        puts Memo::ViewModel::List.new.run(word)
      end
    end
  end
end
