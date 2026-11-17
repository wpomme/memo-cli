# frozen_string_literal: true

module Memo
  class SubCommand
    SUB_COMMAND_DISPATCH = {
      'read' => 'Read',
      '-r' => 'Read',
      'search' => 'Search',
      '-s' => 'Search',
      'dirs' => 'Dirs',
      '-d' => 'Dirs',
      'tag' => 'Tag',
      'tags' => 'Tags',
      '-t' => 'Tags',
      'list' => 'List',
      '-l' => 'List',
      'help' => 'Help',
      '-h' => 'Help',
      'version' => 'Version',
      '-V' => 'Version'
    }.freeze
    def execute(argv)
      first = argv.shift

      return Memo::SubCommandParser::Help.new.execute if first.nil?

      klass_name = SUB_COMMAND_DISPATCH[first]
      if klass_name.nil?
        Memo::SubCommandParser::Read.new.execute(argv: [first])
      else
        klass = Object.const_get("Memo::SubCommandParser::#{klass_name}")
        klass.new.execute(argv: argv)
      end
    end
  end
end
