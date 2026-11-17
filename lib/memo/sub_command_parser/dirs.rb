# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Dirs
      include Memo::SubCommandParser

      def execute(argv: '')
        parse_no_arguments(str: 'dirs', argv:)
      end
    end
  end
end
