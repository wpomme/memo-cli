# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Search
      include Memo::NewCommandParser

      def execute(argv: '')
        parse_one_argument(str: 'search', argv:)
      end
    end
  end
end
