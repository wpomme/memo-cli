# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Search
      include Memo::SubCommandParser

      def execute(argv: '')
        parse_one_argument(str: 'search', argv:)
      end
    end
  end
end
