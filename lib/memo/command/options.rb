require 'optparse'

module Memo
  class Command
    module Options
      ParsedOptions = Data.define(:argv)

      ## TODO: parse_v2を作成する
      HELP_COMMANDS = %w[help -h --help].freeze
      VERSION_COMMANDS = %w[version -v -V --version].freeze
      SUB_COMMANDS = %w[list read dirs].freeze

      # シンボルか文字列の配列のどちらかを返す
      # シンボルを返す場合、ユーザーにメッセージを表示してコマンドを終了する意図
      # 文字列の配列を返す場合は、この文字列により、docsで処理を実行する
      def self.parse_v2(argv)
        symbol_or_commands = parse_v2_aux(argv)
        return unless symbol_or_commands.is_a(Symbol)

        to_user_message(symbol_or_commands)
      end

      # CLIからユーザーにメッセージを表示して終了する
      # メッセージはヘルプコマンドかバージョンコマンドか、エラーメッセージ
      # メッセージを動的に生成するためにargsをnewに渡してクラスインスタンス変数とした方がいいかも
      def self.to_user_message(symbol)
        too_many_args_message = "引数の数が多すぎます。"
        how_to_use_message = <<~HELP
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

        message_map = {
          too_many_args: too_many_args_message,
          how_to_use: how_to_use_message,
          version: Memo::VERSION
        }

        exit_status = Set.new(%i[how_to_use version]).include?(symbol) || 2
        puts message_map[symbol]
        exit exit_status
      end

      def self.parse_v2_aux(argv)
        return :too_many_args if argv.length > 3

        case argv.length
        when 0
          :how_to_use
        when 1
          first = argv.first
          return :how_to_use if HELP_COMMANDS.to_set.include?(first)

          :version if VERSION_COMMANDS.to_set.include?(first)

          # if SUB_COMMANDS.to_set.include?(first)
          #   when
          #   case 'dirs'
          #     :dirs
          # end
        when 2
          default
          raise OptionParser::ParseError, "There is wrong with the arguments."
        end
      end

      ## end parse_v2

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
