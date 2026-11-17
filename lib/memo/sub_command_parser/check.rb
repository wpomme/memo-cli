# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Check
      include Memo::SubCommandParser

      def execute(argv: '')
        parse_no_arguments(str: 'check', argv:)
      end
    end
  end
end
