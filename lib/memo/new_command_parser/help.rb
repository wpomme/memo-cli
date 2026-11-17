# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Help
      include Memo::HelpMessage
      include Memo::NewCommandParser

      def execute(str: 'help', argv: nil)
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
