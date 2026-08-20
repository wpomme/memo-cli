# frozen_string_literal: true

require "optparse"

module Memo
  class SubCommandParser
    include Message

    # TODO: parse_procを作成して、opts.onひブロック引数として渡して、opts.onをeachで作成する
    # TODO: -rや-sでもコマンドが動くようになっているはず。テストコードを修正する
    SUB_COMMAND_SPEC = Struct.new(:sub_command_form, :long_form, :short_form, :desc, :args_type, :long_form_with_args) do
      def to_opts(word)
        short_form if deconstruct_keys(%i[sub_command_form long_form short_form]).values.include?(word)
      end
    end

    HELP_COMMAND_SPEC = SUB_COMMAND_SPEC.new("help", "--help", "-h", "memoコマンドのヘルプ", :none, nil)
    READ_COMMAND_SPEC = SUB_COMMAND_SPEC.new("read", "--read", "-r", "対象のメモを全文表示する", :required, "--read WORD")
    LIST_COMMAND_SPEC = SUB_COMMAND_SPEC.new("list", "--list", "-l", "メモの一覧を表示する", :optional, "--list [DIRS]")
    DIRS_COMMAND_SPEC = SUB_COMMAND_SPEC.new("dirs", "--dirs", "-d", "メモの中のディレクトリの一覧を表示する", :none, nil)
    SEARCH_COMMAND_SPEC = SUB_COMMAND_SPEC.new("search", "--search", "-s", "検索した文字列で全てのメモを全文検索する", :required, "--search WORD")

    SUB_COMMANDS_SPEC = [HELP_COMMAND_SPEC, READ_COMMAND_SPEC, LIST_COMMAND_SPEC, DIRS_COMMAND_SPEC, SEARCH_COMMAND_SPEC].freeze
    SUB_COMMAND_FIND = lambda { |word|
      SUB_COMMANDS_SPEC.find { |spec| spec.to_opts(word) }
    }

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

      found = SUB_COMMAND_FIND.call(first)

      # 引数がゼロの場合、ヘルプメッセージを表示する
      opts.parse!(['-h']) if first.nil?

      if found.nil?
        # first がどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
        opts.parse!(['-r'] + [first])
      else
        return to_error_message(:requires_argv) if found[:args_type] == :required && argv.empty?

        opts.parse!([found[:short_form]] + argv)
      end
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
