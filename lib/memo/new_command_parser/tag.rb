# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Tag
      include Memo::NewCommandParser

      def execute(argv: '')
        parse_one_argument(str: 'tag', argv:)
      end
    end
  end
end
