require 'optparse'

module Memo
  class MemoOptionParser
    HELP_COMMANDS = %w[help -h --help].freeze
    VERSION_COMMANDS = %w[version -v -V --version].freeze
    SUB_COMMANDS = %w[dirs list read].freeze

    def initialize(argv)
      @argv = argv
    end

    def self.word?(word)
      r = /^\w[\w-]{,30}\w?$/
      r.match?(word)
    end

    # CLIからユーザーにメッセージを表示して終了する
    # ユーザーメッセージかエラーメッセージでexitのステータスが変わる
    def self.to_user_message(symbol)
      too_many_argv_message = "引数の数が多すぎます。"
      help_message = <<~HELP
        Usage:
        # メモの一覧を表示する
        memo list

        # そのディレクトリの中になるメモの一覧を表示する
        memo list <dirs>

        # 該当のメモを全文表示する
        memo read <word>

        # メモのフォルダ一覧を表示する
        memo dirs
      HELP

      # 例: dirsは引数を取りません。readの後には調べたいキーワードを入れてください。
      redundant_argv_message = "余分な引数があります。"
      requires_argv_message = "引数が必要です。"
      unknown_message = "想定されていない引数です。引数は32文字以内です。"

      user_message_map = {
        help: help_message,
        version: Memo::VERSION
      }

      error_message_map = {
        too_many_argv: too_many_argv_message,
        redundant_argv: redundant_argv_message,
        requires_argv: requires_argv_message,
        unknown: unknown_message
      }

      # true or 2
      exit_status = Set.new(user_message_map.keys).include?(symbol) || 2

      if exit_status
        puts user_message_map[symbol]
      else
        puts error_message_map[symbol]
      end

      exit exit_status
    end

    # とりあえず
    def continue_command(symbol)
      symbol
    end

    # parse_sub_commandから値を受け取って、to_user_messageか、commandの処理を続けるかを判断する
    def self.option_visitor(_command_symbol, _rest_argc)
      {
        help: {
          0 => to_user_message(:help),
          1 => to_user_message(:redundant_argv)
        },
        version: {
          0 => to_user_message(:version),
          1 => to_user_message(:redundant_argv)
        },
        dirs: {
          0 => continue_command(:dirs),
          1 => to_user_message(:redundant_argv)
        },
        list: {
          0 => continue_command(:list),
          1 => continue_command(:list_with_argv),
          2 => to_user_message(:redundant_argv)
        },
        read: {
          0 => to_user_message(:requires_argv),
          1 => continue_command(:read),
          2 => continue_command(:redundant_argv)
        },
        word: {
          0 => continue_command(:read),
          1 => to_user_message(:redundant_argv)
        },
        unknown: {
          0 => to_user_message(:unknown)
        }
      }
    end

    # コマンドの種別と残りの引数の数を返す
    def self.parse_sub_command(argv)
      new(argv)
      ## 引数が多すぎる場合はエラーを返す。
      ## 残りの引数の数に意味がないためnilを返す
      return :too_many_argv, nil if argv.length > 4

      return :help, 0 if argv.empty?

      first = argv.first
      rest_argc = argv.length - 1

      return :help, rest_argc if HELP_COMMANDS.to_set.include?(first)
      return :version, rest_argc if VERSION_COMMANDS.to_set.include?(first)

      return first.intern, rest_argc if SUB_COMMANDS.include?(first)

      return first, rest_argc if word?(first)

      [:unknown, nil]
    end
  end

  class Command
    module Options
      ParsedOptions = Data.define(:argv)

      def self.parse!(argv)
        parsed = command_parser.order(argv)
        sub_parsed = sub_command_parser(parsed)
        ParsedOptions.new(argv: sub_parsed)
      end

      def self.command_parser
        # memo -v / memo --version
        OptionParser.new do |opt|
          opt.banner = <<-HELP
    Usage:
    # メモの一覧を表示する
    memo list

    # そのディレクトリの中になるメモの一覧を表示する
    memo list <dirs>

    # 該当のメモを全文表示する
    memo read <word>

    # メモのフォルダ一覧を表示する
    memo dirs
          HELP
          opt.on_head('-h', '--help') do |_|
            puts opt.help
            exit
          end
          opt.on_head('-v', '--version') do |_|
            opt.version = Memo::VERSION
            puts opt.ver
            exit
          end
        end
      end

      def self.sub_command_parser(argv)
        case argv.first
        when 'list'
          raise Options::ParseError, '"list" do not take 2 or more parameters' if argv.length > 2
        when 'dirs'
          raise Options::ParseError, '"dirs" do not take any parameters' if argv.length > 1
        when 'read'
          raise Options::ParseError, '"read" must take an argument' if argv.length == 1 || argv.length > 2
        else
          raise OptionParser::ParseError, "unknown sub command"
        end
        argv
      end
    end
  end
end
