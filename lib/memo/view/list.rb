# frozen_string_literal: true

module Memo
  module View
    class List
      def initialize
        @vw = Memo::ViewModel::List.new
      end

      def execute(word: '')
        return default if word == true

        directory(word)
      end

      private

      def default
        puts @vw.execute
      end

      def directory(word)
        @vw.directory(word).each do |line|
          puts line
        end
      end
    end
  end
end
