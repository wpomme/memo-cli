# frozen_string_literal: true

module Memo
  class SubCommandParser
    include Memo::Message
    include Memo::HelpMessage

    Spec = Data.define(:short, :long, :desc)

    def execute(argv)
      first = argv.shift

      return parse_help_command if first.nil?

      case first
      when 'read'
        Memo::NewCommandParser::Read.new.execute(argv: argv)
      when 'search'
        Memo::NewCommandParser::Search.new.execute(argv: argv)
      when 'tag'
        Memo::NewCommandParser::Tag.new.execute(argv: argv)
      when 'dirs'
        Memo::NewCommandParser::Dirs.new.execute(argv: argv)
      when 'tags'
        Memo::NewCommandParser::Tags.new.execute(argv: argv)
      when 'list'
        parse_list_command(argv: argv)
      when 'help'
        parse_help_command(argv: argv)
      when 'version', '-V'
        Memo::NewCommandParser::Version.new.execute(argv: argv)
      else
        Memo::NewCommandParser::Read.new.execute(argv: [first])
      end
    end

    def parse_list_command(str: 'list', argv: nil)
      to_error_message(:too_many_args, str) if argv.size > 1

      return { str => true } if argv.empty?

      opt = argv[0]

      to_error_message(:too_long_args, str) if opt.size > 32

      return { str => :duplicate } if ['-d', '--duplicate'].include?(opt)

      { str => opt }
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
