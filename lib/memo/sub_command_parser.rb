# frozen_string_literal: true

module Memo
  class SubCommandParser
    HELP_COMMAND_SPEC = Memo::Model::SUB_COMMAND_SPEC.new("help", "--help", "-h", "memoコマンドのヘルプ", :none, nil, nil)
    READ_COMMAND_SPEC = Memo::Model::SUB_COMMAND_SPEC.new("read", "--read", "-r", "対象のメモを全文表示する", :required, "--read WORD", proc do |word|
      self.parsed = [:read, word]
    end)
    LIST_COMMAND_SPEC = Memo::Model::SUB_COMMAND_SPEC.new("list", "--list", "-l", "メモの一覧を表示する", :optional, "--list [DIRS]", proc do |dirs|
      self.parsed = dirs ? [:list, dirs] : [:list]
    end)
    DIRS_COMMAND_SPEC = Memo::Model::SUB_COMMAND_SPEC.new("dirs", "--dirs", "-d", "メモの中のディレクトリの一覧を表示する", :none, nil, proc do
      self.parsed = [:dirs]
    end)
    SEARCH_COMMAND_SPEC = Memo::Model::SUB_COMMAND_SPEC.new("search", "--search", "-s", "検索した文字列で全てのメモを全文検索する", :required, "--search WORD", proc do |word|
      self.parsed = [:search, word]
    end)
    TAGS_COMMAND_SPEC = Memo::Model::SUB_COMMAND_SPEC.new("tags", "--tags", "-t", "タグ名とそのタグ名が付いたファイル名の一覧を表示する", :none, nil, proc do |_word|
      self.parsed = [:tags]
    end)

    SUB_COMMANDS_SPEC = [READ_COMMAND_SPEC, LIST_COMMAND_SPEC, DIRS_COMMAND_SPEC, SEARCH_COMMAND_SPEC, TAGS_COMMAND_SPEC, HELP_COMMAND_SPEC].freeze

    # 引数が登録されているサブコマンドであれば、そのサブコマンドの構造体SPECを返す
    #
    # @return [SUB_COMMANDS_SPEC]
    SUB_COMMAND_FIND = lambda { |word|
      SUB_COMMANDS_SPEC.find { |spec| spec.to_opts(word) }
    }

    class << self
      attr_accessor :parsed
    end

    def self.parse!(argv)
      first = argv.shift

      parser

      found = SUB_COMMAND_FIND.call(first)

      # 引数がゼロの場合、ヘルプメッセージを表示する
      parser.parse!(['-h']) if first.nil?

      if found.nil?
        # firstがどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
        parser.parse!(['-r'] + [first])
      else
        return to_error_message(:requires_argv) if found[:argv_type] == :required && argv.empty?

        parser.parse!([found[:short_form]] + argv)
      end

      parsed unless parsed.nil?
    end

    def self.parser
      OptionParser.new do |opts|
        opts.banner = "memo CLI: ローカルのメモフォルダをコマンドで閲覧、検索するためのコマンド"
        opts.separator ""
        opts.separator "使い方: memo subcommand [arguments]"
        opts.separator "例: memo list cli => memoフォルダ内のcliフォルダの中のメモの一覧を返す"
        opts.separator "サブコマンドの--は省略可能"
        opts.separator "また、サブコマンドを省略した場合はmemo readを実行するものとみなされる"
        opts.separator "例: memo ls => フォルダ内のls.mdを検索して、あればls.mdを全文表示する"

        opts.separator ""
        opts.separator "サブコマンド(subcommand)のリスト:"

        # OptionParserにそれぞれのサブコマンドを登録する
        SUB_COMMANDS_SPEC.each do |spec|
          if spec.sub_command_form == "help"
            # helpコマンドを呼び出したときの処理がopts.on_tailのブロックに記載がある。
            opts.on(spec.short_form, spec.long_form, spec.desc) do
              puts opts
              exit 0
            end
          elsif spec.argv_type == :none
            opts.on(spec.short_form, spec.long_form, spec.desc, &spec.parsed_block)
          else
            opts.on(spec.short_form, spec.long_form_with_argv, String, spec.desc, &spec.parsed_block)
          end
        end
      end
    end

    # とりあえず作成
    def self.to_error_message(symbol)
      error_message_map = {
        requires_argv: "引数が足りません。"
      }
      puts error_message_map[symbol]
      exit 2
    end
  end
end
