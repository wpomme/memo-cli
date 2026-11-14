# frozen_string_literal: true

module Memo
  module View
    class List
      include Memo::View

      def initialize
        @vw = Memo::ViewModel::List.new
      end

      def execute(word: '')
        if word == true
          @vw.default.each do |line|
            puts line
          end
        elsif word == :duplicate
          @vw.duplicate.each do |line|
            puts line
          end
        else
          @vw.directory(word).each do |line|
            puts line
          end
        end
      end
    end
  end
end
