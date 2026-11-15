# frozen_string_literal: true

module Memo
  module View
    class Read
      def execute(word:)
        puts Memo::ViewModel::Read.new.execute(word)
      end
    end
  end
end
