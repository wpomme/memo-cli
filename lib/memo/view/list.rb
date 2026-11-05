# frozen_string_literal: true

module Memo
  module View
    class List
      def execute(word: '')
        puts Memo::ViewModel::List.new.execute(word)
      end
    end
  end
end
