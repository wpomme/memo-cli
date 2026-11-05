# frozen_string_literal: true

module Memo
  module View
    class Tags
      def run(word: '')
        puts Memo::ViewModel::Tags.new.run(word)
      end
    end
  end
end
