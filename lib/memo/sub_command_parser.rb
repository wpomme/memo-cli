# frozen_string_literal: true

require "optparse"

module Memo
  class SubCommandParser
    include Message

    SUB_COMMAND_MAP = {
      'read' => '-r',
      'list' => '-l',
      'dirs' => '-d',
      'search' => '-s'
    }.freeze
    SUB_COMMAND_REQUIRED_ARGC = {
      'read' => 1,
      'list' => 0,
      'dirs' => 0,
      'search' => 1
    }.freeze

    def self.parse!(argv)
      first = argv.shift

      opts = OptionParser.new do |opts|
        opts.banner = HELP_MESSAGE
        opts.on('-h', '--help', "memoコマンドのヘルプ") do
          puts opts.banner
          exit
        end
        opts.on('-r', '--read WORD', String, '対象のメモを全文表示する') do |word|
          return [:read, word?(word)]
        end
        opts.on('-l', '--list [DIRS]', String, 'メモの一覧を表示する') do |dirs|
          return dirs ? [:list, word?(dirs)] : [:list]
        end
        opts.on('-d', '--dirs', 'メモの中のディレクトリの一覧を表示する') do
          return [:dirs]
        end
        opts.on('-s', '--search WORD', String, '検索した文字列で全てのメモを全文検索する') do |word|
          return [:search, word]
        end
      end

      return opts.parse!(['-h']) if HELP_COMMANDS.to_set.include?(first)

      if SUB_COMMAND_MAP.key?(first)
        return to_error_message(:requires_argv) if SUB_COMMAND_REQUIRED_ARGC[first] > argv.length

        opts.parse!([SUB_COMMAND_MAP[first]] + argv)
      end

      # first がどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
      opts.parse!(['-r'] + [first])
    end

    # とりあえず作成
    def self.word?(word)
      r = %r@^\w[\w/-]{,30}\w?$@
      if r.match?(word)
        word
      else
        to_error_message(:invalid_word)
      end
    end

    # とりあえず作成
    def self.to_error_message(symbol)
      error_message_map = {
        requires_argv: "引数が足りません。",
        invalid_word: "不正な文字列です。"
      }
      puts error_message_map[symbol]
      exit 2
    end
  end
end
