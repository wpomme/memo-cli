# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Version
      include Memo::SubCommandParser

      def execute(argv: '')
        parse_no_arguments(str: 'version', argv:)
      end
    end
  end
end
