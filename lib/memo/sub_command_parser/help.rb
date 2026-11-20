# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Help
      include Memo::HelpMessage
      include Memo::SubCommandParser

      def execute(argv: nil)
        second = argv&.first

        # memo / memo helpの場合は、ヘルプの概要を表示する
        if second.nil? || argv.nil?
          puts GENERAL
        else
          dispatched = Memo::SubCommand::SUB_COMMAND_DISPATCH[second]

          if dispatched.nil?
            to_error_message(:unknown_command, second)
          else
            puts Object.const_get("Memo::HelpMessage::#{dispatched.upcase}_DETAIL")
          end
        end

        exit 0
      end
    end
  end
end
