# frozen_string_literal: true

require "optparse"

module Memo
  # NOTE: できればやりたいこと
  #  1. SUB_COMMAND_SPECをModelに移動してもいいかも
  #  2. ヘルプメッセージをSUB_COMMAND_SPEC.descから生成できないか？
  #  3. parsedを返す場合と、ヘルプ・ユーザーメッセージを返す場合を明確にする
  #  4. to_error_message => to_user_messageにしてhelp_messageと共用化してもいい
  class SubCommandParser
    include Message

    # サブコマンドの詳細を作成するための構造体
    #
    # @!attribute [r] :sub_command_form
    #   @return [String] memoの後にこの値を指定するとサブコマンドとして機能する文字列
    # @!attribute [r] :long_form
    #   @return [String] サブコマンドのロングフォーム。OptionParser#onに準ずる
    # @!attribute [r] :short_form
    #   @return [String] サブコマンドのショートフォーム。OptionParser#onに準ずる
    # @!attribute [r] :desc
    #   @return [String] サブコマンドの詳細。OptionParser#onに準ずる
    # @!attribute [r] :argv_type
    #   @return [Symbol] 該当のサブコマンドの引数の取り方を指定する。
    #     none: 引数を取らない
    #     optional: 引数をオブションで取る
    #     required: 引数を必須で取る
    # @!attribute [r] :long_form_with_argv
    #   @return [String | Void] サブコマンドが引数を取る場合に、OptionParser#onのロングフォームに指定する値を定めたもの
    # @!attribute [r] :parsed_block
    #   @return [String | Void] OptionsParser#parse!で実行する手続き
    SUB_COMMAND_SPEC = Struct.new(:sub_command_form, :long_form, :short_form, :desc, :argv_type, :long_form_with_argv, :parsed_block) do
      def initialize(...)
        super
        freeze
      end

      # サブコマンドのそれぞれの形式を配列で返す。テストコード用
      # @return [Array<String>]
      def take_command_forms
        deconstruct_keys(%i[sub_command_form long_form short_form]).values
      end

      # サブコマンドを受け取ったら、そのショートフォームを返す
      # @params word [<String>]
      # @return [<String>]
      def to_opts(word)
        short_form if deconstruct_keys(%i[sub_command_form long_form short_form]).values.include?(word)
      end
    end

    HELP_COMMAND_SPEC = SUB_COMMAND_SPEC.new("help", "--help", "-h", "memoコマンドのヘルプ", :none, nil, proc do
      puts Message::HELP_MESSAGE
      exit
    end)
    READ_COMMAND_SPEC = SUB_COMMAND_SPEC.new("read", "--read", "-r", "対象のメモを全文表示する", :required, "--read WORD", proc do |word|
      self.parsed = [:read, word]
    end)
    LIST_COMMAND_SPEC = SUB_COMMAND_SPEC.new("list", "--list", "-l", "メモの一覧を表示する", :optional, "--list [DIRS]", proc do |dirs|
      self.parsed = dirs ? [:list, dirs] : [:list]
    end)
    DIRS_COMMAND_SPEC = SUB_COMMAND_SPEC.new("dirs", "--dirs", "-d", "メモの中のディレクトリの一覧を表示する", :none, nil, proc do
      self.parsed = [:dirs]
    end)
    SEARCH_COMMAND_SPEC = SUB_COMMAND_SPEC.new("search", "--search", "-s", "検索した文字列で全てのメモを全文検索する", :required, "--search WORD", proc do |word|
      self.parsed = [:search, word]
    end)

    SUB_COMMANDS_SPEC = [HELP_COMMAND_SPEC, READ_COMMAND_SPEC, LIST_COMMAND_SPEC, DIRS_COMMAND_SPEC, SEARCH_COMMAND_SPEC].freeze

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

      opts = OptionParser.new do |opts|
        opts.banner = HELP_MESSAGE

        SUB_COMMANDS_SPEC.each do |spec|
          if spec.argv_type == :none
            opts.on(spec.short_form, spec.long_form, spec.desc, &spec.parsed_block)
          else
            opts.on(spec.short_form, spec.long_form_with_argv, String, spec.desc, &spec.parsed_block)
          end
        end
      end

      found = SUB_COMMAND_FIND.call(first)

      # 引数がゼロの場合、ヘルプメッセージを表示する
      opts.parse!(['-h']) if first.nil?

      if found.nil?
        # firstがどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
        opts.parse!(['-r'] + [first])
      else
        return to_error_message(:requires_argv) if found[:argv_type] == :required && argv.empty?

        opts.parse!([found[:short_form]] + argv)
      end

      parsed unless parsed.nil?
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
