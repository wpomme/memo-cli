# frozen_string_literal: true

module Memo
  module View
    class Tags
      def initialize(target_dirs: Memo::Config.target_dirs)
        @vw = Memo::ViewModel::Tags.new(target_dirs: target_dirs)
      end

      def execute(word:)
        return puts @vw.send(word) if %i[name count empty].include?(word)

        puts @vw.default
      end
    end
  end
end
