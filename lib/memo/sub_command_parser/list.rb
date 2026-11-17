# frozen_string_literal: true

module Memo
  module SubCommandParser
    class List
      include Memo::SubCommandParser

      def execute(str: 'list', argv: '')
        rest = OptionParser.new.parse(argv)

        to_error_message(:too_many_args, str) if rest.size > 1

        if rest.size == 1
          to_error_message(:too_long_args, str) if rest[0].size > 32

          return { str => rest[0] }
        end

        { str => true }
      end
    end
  end
end
