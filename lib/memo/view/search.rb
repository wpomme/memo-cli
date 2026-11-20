# frozen_string_literal: true

module Memo
  module View
    class Search
      def initialize(target_dirs: Memo::Config.target_dirs)
        @vw = Memo::ViewModel::Search.new(target_dirs: target_dirs)
      end

      def execute(word:)
        puts @vw.execute(word)
      end
    end
  end
end
