# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Dirs
      include Memo::NewCommandParser

      def execute(str: 'dirs', argv: '')
        parse_no_arguments(str:, argv:)
      end
    end
  end
end
