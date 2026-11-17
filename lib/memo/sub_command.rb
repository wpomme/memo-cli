# frozen_string_literal: true

module Memo
  class SubCommand
    SUB_COMMAND_DISPATCH = {
      'Read' => %w[read -r],
      'Search' => %w[search -s],
      'Dirs' => %w[dirs -d],
      'Tag' => %w[tag],
      'Tags' => %w[tags -t],
      'List' => %w[list -l],
      'Help' => %w[help -h],
      'Version' => %w[version -V]
    }.flat_map { |k, vs| vs.map { |v| [v, k] } }.to_h.freeze

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
