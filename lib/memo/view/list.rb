# frozen_string_literal: true

module Memo
  module View
    class List
      def initialize(target_dirs: Memo::Config.target_dirs)
        @vw = Memo::ViewModel::List.new(target_dirs: target_dirs)
      end

      def execute(word: '')
        return default if word == true

        directory(word)
      end

      private

      def default
        puts @vw.default
      end

      def directory(word)
        puts @vw.directory(word)
      end
    end
  end
end
