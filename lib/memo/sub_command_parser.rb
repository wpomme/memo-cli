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
        parse_one_argument(first.intern, argv: argv)
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
        parse_one_argument(:read, argv: [first])
      end
    end

    def parse_no_arguments(sym: :dirs, argv: nil)
      to_error_message(:too_many_args, sym) unless argv.empty?

      { sym => true }
    end

    def parse_one_argument(sym, argv: nil)
      to_error_message(:no_given_args, sym) if argv.empty?

      to_error_message(:too_many_args, sym) if argv.size > 1

      { sym => argv[0] }
    end

    def parse_tags_command(sym: :tags, argv: nil)
      parsed = {}

      specs = tags_spec_list

      OptionParser.new do |opt|
        specs.each do |spec|
          opt.on(spec.short, spec.long, spec.desc)
        end
      end
        .parse(argv, into: parsed)

      to_error_message(:too_many_options, :tags) if parsed.size > 1

      value = parsed.empty? || parsed.keys[0]

      { sym => value }
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

    def parse_list_command(sym: :list, argv: nil)
      to_error_message(:too_many_args, sym) if argv.size > 1

      return { sym => true } if argv.empty?

      opt = argv[0]

      to_error_message(:too_long_args, sym) if opt.size > 32

      return { sym => :count } if ['-c', '--count'].include?(opt)

      return { sym => :duplicate } if ['-d', '--duplicate'].include?(opt)

      { sym => opt }
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

    def to_error_message(error_message_symbol, sub_command_symbol)
      dispatch = {
        read: 'read',
        search: 'search',
        dirs: 'dirs',
        list: 'list',
        tag: 'tag',
        tags: 'tags'
      }.freeze

      error_message_map = {
        no_given_args: NO_GIVEN_ARGS.gsub('CLI', dispatch[sub_command_symbol]),
        too_many_args: TOO_MANY_ARGS.gsub('CLI', dispatch[sub_command_symbol]),
        too_many_options: TOO_MANY_OPTIONS.gsub('CLI', dispatch[sub_command_symbol]),
        too_long_args: TOO_LONG_ARGS,
        unknown_command: UNKNOWN_COMMAND
      }
      puts error_message_map[error_message_symbol]
      exit 2
    end
  end
end
