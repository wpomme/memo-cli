# frozen_string_literal: true

module Memo
  module View
    class Tags
      def initialize
        @vw = Memo::ViewModel::Tags.new
      end

      def execute(word: '')
        return name if word == :name

        return count if word == :count

        return empty if word == :empty

        default
      end

      private

      def default
        puts @vw.execute
      end

      def empty
        @vw.empty.each do |line|
          puts line
        end
      end

      def count
        puts @vw.count
      end

      def name
        puts @vw.name
      end
    end
  end
end
