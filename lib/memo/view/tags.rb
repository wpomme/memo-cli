# frozen_string_literal: true

module Memo
  module View
    class Tags
      def initialize
        @vw = Memo::ViewModel::Tags.new
      end

      def execute(word: '')
        return puts @vw.send(word) if %i[name count empty].include?(word)

        puts @vw.default
      end
    end
  end
end
