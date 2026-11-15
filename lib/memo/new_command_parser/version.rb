# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Version
      include Memo::NewCommandParser

      def execute(str: 'version', argv: '')
        parse_no_arguments(str:, argv:)
      end
    end
  end
end
