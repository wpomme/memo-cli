# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Version
      include Memo::NewCommandParser

      def execute(argv: '')
        parse_no_arguments(str: 'version', argv:)
      end
    end
  end
end
