# frozen_string_literal: true

module Memo
  module SubCommandParser
    include Memo::Message

    def to_error_message(error_message_symbol, sub_command)
      error_message_map = {
        no_given_args: NO_GIVEN_ARGS.gsub('CLI', sub_command),
        too_many_args: TOO_MANY_ARGS.gsub('CLI', sub_command),
        too_many_options: TOO_MANY_OPTIONS.gsub('CLI', sub_command),
        too_long_args: TOO_LONG_ARGS,
        unknown_command: UNKNOWN_COMMAND
      }
      puts error_message_map[error_message_symbol]
      exit 2
    end

    def parse_no_arguments(str:, argv: '')
      to_error_message(:too_many_args, str) unless argv.empty?

      { str => nil }
    end

    def parse_one_argument(str:, argv: nil)
      to_error_message(:no_given_args, str) if argv.empty?

      to_error_message(:too_many_args, str) if argv.size > 1

      { str => argv[0] }
    end
  end
end
