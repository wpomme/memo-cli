# frozen_string_literal: true

module Memo
  module View
    class Tags
      include Memo::View

      def initialize
        @vw = Memo::ViewModel::Tags.new
      end

      def execute(word: '')
        case word
        when true
          puts @vw.execute
        when :empty
          @vw.empty.each do |line|
            puts line
          end
        when :count
          puts @vw.count
        when :name
          puts @vw.name
        else
          raise StandardError, "There is wrong with the word: #{word}."
        end
      end
    end
  end
end
