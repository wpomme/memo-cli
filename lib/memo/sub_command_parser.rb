# frozen_string_literal: true

module Memo
  class SubCommandParser
    include Memo::Message
    include Memo::HelpMessage

    Spec = Data.define(:short, :long, :desc)

    def run(argv)
      execute(argv)
    end

    private

    def execute(argv)
      first = argv.shift

      return parse_help_command if first.nil?

      case first
      when 'read', 'search', 'tag'
        parse_one_argument(first, argv: argv)
      when 'dirs'
        parse_no_arguments(argv: argv)
      when 'tags'
        parse_tags_command(argv: argv)
      when 'list'
        parse_list_command(argv: argv)
      when 'help'
        parse_help_command(argv: argv)
      when 'version', '-V'
        parse_version_command
      else
        parse_one_argument('read', argv: [first])
      end
    end

    def parse_no_arguments(str: 'dirs', argv: nil)
      to_error_message(:too_many_args, str) unless argv.empty?

      { str => true }
    end

    def parse_one_argument(str, argv: nil)
      to_error_message(:no_given_args, str) if argv.empty?

      to_error_message(:too_many_args, str) if argv.size > 1

      { str => argv[0] }
    end

    def parse_tags_command(str: 'tags', argv: nil)
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

    def parse_list_command(str: 'list', argv: nil)
      to_error_message(:too_many_args, str) if argv.size > 1

      return { str => true } if argv.empty?

      opt = argv[0]

      to_error_message(:too_long_args, str) if opt.size > 32

      return { str => :count } if ['-c', '--count'].include?(opt)

      return { str => :duplicate } if ['-d', '--duplicate'].include?(opt)

      { str => opt }
    end

    def parse_version_command
      puts Memo::VERSION
      exit 0
    end

    def parse_help_command(argv: nil)
      # TODO: コマンドごとのヘルプが欲しい
      second = argv.first unless argv.nil?

      if second == 'tags'
        puts TAGS_DETAIL
      elsif second == 'read'
        puts READ_DETAIL
      else
        puts GENERAL
      end

      exit 0
    end

    # TODO
    # 引数として取る文字列が有効な形式かどうかを判断する
    # とりあえず、33文字以上ならfalseとする
    # def valid_word?(word)
    #   word.size > 32
    # end

    def to_error_message(error_message_symbol, sub_command)
      error_message_map = {
        no_given_args: NO_GIVEN_ARGS.gsub('CLI', sub_command),
        too_many_args: TOO_MANY_ARGS.gsub('CLI', sub_command),
        too_many_options: TOO_MANY_OPTIONS.gsub('CLI', sub_command),
        too_long_args: TOO_LONG_ARGS,
        unknown_command: UNKNOWN_COMMAND
      }
      puts error_message_map[error_message_symbol]
      exit 2
    end
  end
end
