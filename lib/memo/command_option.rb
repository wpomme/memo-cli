# frozen_string_literal: true

module Memo
  class CommandOption
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

    # サブコマンドの引数が不審な文字列ではないかチェックして、commandに渡す
    # 現状、引数を取るコマンドはlistとreadのみ。また、:wordの場合は、既に文字列のチェックを終えている
    def continue_command(symbol, rest_argc)
      case symbol
      when :dirs
        [:dirs]
      when :read
        [:read, @argv[1]] if word?(@argv[1])
      when :word
        [:read, @argv[0]]
      when :list
        return [:list] if rest_argc.empty?

        [:list, @argv[1]] if word?(@argv[1])
      end
    end

    # サブコマンドと、そのコマンドが取る引数の数のマップがあればいい
    # parse_sub_commandから値を受け取って、to_user_messageか、commandの処理を続けるかを判断する
    # command -> symbol
    # rest_argc -> Numeric or nil
    def self.option_visitor(command, rest_argc)
      # value: Range or Numeric or nil
      argc_map = {
        help: 0,
        version: 0,
        dirs: 0,
        list: 0..1,
        read: 1,
        word: 0,
        unknown: nil,
        too_many_argv: nil
      }
      to_user_message(command) if rest_argc.nil?(rest_argc)

      raise ArgumentError "There is wrong with the arguments." if rest_argc < o

      case argc_map[command].class
      when Numeric
        if argc_map[command] == rest_argc
          continue_command(command, rest_argc)
        elsif argc_map[command] < rest_argc
          to_user_message(:redundant_argv)
        end
        to_user_message(:requires_argv)
      when Range
        if argc_map[command].cover?(rest_argc)
          continue_command(command, rest_argc)
        elsif argc_map(command).max < rest_argc
          to_user_message(:redundant_argv)
        end
        to_user_message(:requires_argv)
      else
        raise ArgumentError, "There is wrong with the arguments."
      end
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

      ## memo <word>はmemo read <word>と同じ動作にする
      return :word, rest_argc if word?(first)

      [:unknown, nil]
    end
  end
end
