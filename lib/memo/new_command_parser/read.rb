# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Read
      include Memo::NewCommandParser

      def execute(argv: '')
        parse_one_argument(str: 'read', argv:)
      end
    end
  end
end
