# frozen_string_literal: true

module Memo
  module NewCommandParser
    class List
      include Memo::HelpMessage
      include Memo::NewCommandParser

      Spec = Data.define(:short, :long, :desc)

      def execute(str: 'list', argv: '')
        parsed = {}
        rest = OptionParser.new do |opt|
          list_spec_list.each do |spec|
            opt.on(spec.short, spec.long, spec.desc)
          end
        end
          .parse(argv, into: parsed)

        to_error_message(:too_many_options, str) if parsed.size > 1
        to_error_message(:too_many_args, str) if rest.size > 1

        if rest.size == 1
          to_error_message(:too_long_args, str) if rest[0].size > 32

          return { str => rest[0] }
        end

        { str => parsed.empty? || parsed.keys[0] }
      end

      def list_spec_list
        duplicate_spec = Spec.new('-d', '--duplicate', LIST_OPTIONS_DUPLICATE)

        spec_list([duplicate_spec])
      end

      def spec_list(specs)
        specs.map do |spec|
          Spec.new(spec.short, spec.long, spec.desc)
        end
      end
    end
  end
end
