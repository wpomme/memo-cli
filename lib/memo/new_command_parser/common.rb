# frozen_string_literal: true

module Memo
  module NewCommandParser
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
  end
end
