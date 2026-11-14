# frozen_string_literal: true

module Memo
  module View
    class Tags
      include Memo::View

      def initialize
        @vw = Memo::ViewModel::Tags.new
      end

      def execute(word: '')
        if word == :empty
          @vw.empty.each do |line|
            puts line
          end
        else
          puts @vw.execute(word)
        end
      end
    end
  end
end
