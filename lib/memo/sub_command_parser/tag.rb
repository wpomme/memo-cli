# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Tag
      include Memo::SubCommandParser

      def execute(argv: '')
        parse_one_argument(str: 'tag', argv:)
      end
    end
  end
end
