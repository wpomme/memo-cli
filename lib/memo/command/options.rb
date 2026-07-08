require 'optparse'

module Memo
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
