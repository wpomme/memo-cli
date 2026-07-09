require "optparse"

module Memo
  class Command
    module Options
      HELP_COMMANDS = %w[-h --help help].freeze
      HELP_MESSAGE = <<~HELP.freeze
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
      ## TODO: ここら辺をまとめたい
      SUB_COMMAND_MAP = {
        'read' => '-r',
        'list' => '-l',
        'dirs' => '-d'
      }.freeze
      SUB_COMMAND_REQUIRED_ARGC = {
        'read' => 1,
        'list' => 0,
        'dirs' => 0
      }.freeze

      class SubCommand
        def self.parse!(argv)
          first = argv.shift

          opts = OptionParser.new do |opts|
            opts.banner = HELP_MESSAGE
            opts.on('-h', '--help', "memoコマンドのヘルプ") do
              puts opts.banner
              exit
            end
            opts.on('-r', '--read WORD', String, '対象のmemoを全文表示する') do |word|
              return [:read, word]
            end
            opts.on('-l', '--list [DIRS]', String, 'memoの一覧を表示する') do |dirs|
              return dirs ? [:list, dirs] : [:list]
            end
            opts.on('-d', '--dirs', 'memoの中のディレクトリの一覧を表示する') do |_dirs|
              return [:dirs]
            end
          end

          # help -> -h として渡す
          return opts.parse!(['-h'] + argv) if HELP_COMMANDS.to_set.include?(first)

          if SUB_COMMAND_MAP.key?(first)
            return :requires_argv if SUB_COMMAND_REQUIRED_ARGC[first] > argv.length

            opts.parse!([SUB_COMMAND_MAP[first]] + argv)
          end

          # first がどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
          # TODO: OptionParserか自作のword?を使いたい
          # parser.send(:read, [first])
          [:read, [first]]
        end

        def self.word?(word)
          r = /^\w[\w-]{,30}\w?$/
          r.match?(word)
        end
      end
    end
  end
end

# Memo::Command::Options::SubCommand.parse!(['list', 'foo'])
# Memo::Command::Options::SubCommand.parse!(['read', 'foo'])
# Memo::Command::Options::SubCommand.parse!(['foo'])
# Memo::Command::Options::SubCommand.parse!(['help'])
# Memo::Command::Options::SubCommand.parse!(['-v'])
