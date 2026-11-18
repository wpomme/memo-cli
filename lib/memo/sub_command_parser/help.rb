# frozen_string_literal: true

module Memo
  module SubCommandParser
    class Help
      include Memo::HelpMessage
      include Memo::SubCommandParser

      def execute(argv: nil)
        # TODO: SubCommand::SubCommandDispatchを流用する
        second = argv&.first

        case second
        when 'check'
          puts CHECK_DETAIL
        when 'dirs'
          puts DIRS_DETAIL
        when 'list'
          puts LIST_DETAIL
        when 'read'
          puts READ_DETAIL
        when 'search'
          puts SEARCH_DETAIL
        when 'tag'
          puts TAG_DETAIL
        when 'tags'
          puts TAGS_DETAIL
        when 'version'
          puts VERSION_DETAIL
        else
          puts GENERAL
        end

        exit 0
      end
    end
  end
end
