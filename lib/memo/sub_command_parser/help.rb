# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Help
      include Memo::HelpMessage
      include Memo::SubCommandParser

      def execute(argv: nil)
        # TODO: コマンドごとのヘルプが欲しい
        second = argv&.first

        if second == 'tags'
          puts TAGS_DETAIL
        elsif second == 'read'
          puts READ_DETAIL
        else
          puts GENERAL
        end

        exit 0
      end
    end
  end
end
