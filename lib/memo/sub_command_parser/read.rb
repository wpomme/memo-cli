# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Read
      include Memo::SubCommandParser

      def execute(argv: '')
        parse_one_argument(str: 'read', argv:)
      end
    end
  end
end
