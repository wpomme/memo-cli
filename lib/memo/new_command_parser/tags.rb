# frozen_string_literal: true

module Memo
  module NewCommandParser
    class Tags
      include Memo::HelpMessage
      include Memo::NewCommandParser

      Spec = Data.define(:short, :long, :desc)

      def execute(str: 'tags', argv: nil)
        parsed = {}

        OptionParser.new do |opt|
          tags_spec_list.each do |spec|
            opt.on(spec.short, spec.long, spec.desc)
          end
        end
          .parse(argv, into: parsed)

        to_error_message(:too_many_options, str) if parsed.size > 1

        { str => parsed.empty? || parsed.keys[0] }
      end

      def tags_spec_list
        name_spec = Spec.new('-n', '--name', TAGS_OPTIONS_NAME)
        count_spec = Spec.new('-c', '--count', TAGS_OPTIONS_COUNT)
        empty_spec = Spec.new('-e', '--empty', TAGS_OPTIONS_EMPTY)

        spec_list([name_spec, count_spec, empty_spec])
      end

      def spec_list(specs)
        specs.map do |spec|
          Spec.new(spec.short, spec.long, spec.desc)
        end
      end
    end
  end
end
