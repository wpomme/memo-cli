# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Dirs
      include Memo::NewCommandParser

      def execute(argv: '')
        parse_no_arguments(str: 'dirs', argv:)
      end
    end
  end
end
