# frozen_string_literal: true

module Memo
  module View
    class Tags
      def execute(word: '')
        puts Memo::ViewModel::Tags.new.execute(word)
      end
    end
  end
end
