# frozen_string_literal: true

module Memo
  class NewSubCommandParser
    def self.run(argv)
      new.execute(argv)
    end

    # TODO: Visitorパターンを参考にして後ほど修正する
    def execute(argv)
      first = argv.shift

      return sub_parser(:help) if first.nil?

      case first
      when 'read', 'search', 'tag'
        parse_one_argument(first.intern, argv: argv)
      when 'dirs'
        parse_no_arguments(first.intern, argv: argv)
      when 'list'
        sub_parser(:list, argv: argv)
      when 'tags'
        sub_parser(:tags, argv: argv)
      when 'check'
        sub_parser(:check, argv: argv)
      when 'help'
        sub_parser(:help, argv: argv)
      when 'version', '-V'
        sub_parser(:version, argv: argv)
      else
        sub_parser(:read, argv: [first])
      end
    end

    private

    def parse_no_arguments(sym, argv: nil)
      to_error_message(:too_many_args, sym) unless argv.empty?

      { sym => true }
    end

    def parse_one_argument(sym, argv: nil)
      to_error_message(:no_given_args, sym) if argv.empty?

      to_error_message(:too_many_args, sym) if argv.size > 1

      { sym => argv[0] }
    end

    def sub_parser(sym, argv: nil)
      case sym
      when :list
        to_error_message(:too_many_args, :list) if argv.size > 1

        return { list: true } if argv.empty?

        opt = argv[0]

        to_error_message(:too_long_args, :list) if opt.size > 32

        return { list: :count } if ['-c', '--count'].include?(opt)

        { list: opt }
      when :tags
        parsed = {}

        OptionParser.new do |opt|
          opt.on('-n', '--name', 'タグ名のみを表示する')
          opt.on('-c', '--count', 'タグ名とそのタグが付いているファイルの数を表示する')
        end
          .parse(argv, into: parsed)

        # 違うオプションを同時に取ることはできません。というようなエラーを返す
        # to_error_message(:foo, :tags) if parsed.size > 1

        value = parsed.empty? || parsed.keys[0]

        { tags: value }
      when :check
        parsed = {}

        OptionParser.new do |opt|
          opt.on('-d', '--duplicate', '重複したファイル名の情報を表示する')
          opt.on('-e', '--empty', 'タグの付いていないファイルの一覧を表示する')
        end
          .parse(argv, into: parsed)

        value = parsed.empty? || parsed.keys[0]

        { check: value }
      # TODO
      # when :help
      when :version
        puts Memo::VERSION
      else
        [sym, argv]
      end
    end

    # TODO
    # 引数として取る文字列が有効な形式かどうかを判断する
    # とりあえず、33文字以上ならfalseとする
    # def valid_word?(word)
    #   word.size > 32
    # end

    def to_error_message(error_message_symbol, sub_command_symbol)
      dispatch = {
        read: 'read',
        search: 'search',
        dirs: 'dirs',
        list: 'list',
        tag: 'tag'
      }.freeze

      error_message_map = {
        no_given_args: Message::NO_GIVEN_ARGS.gsub('CLI', dispatch[sub_command_symbol]),
        too_many_args: Message::TOO_MANY_ARGS.gsub('CLI', dispatch[sub_command_symbol]),
        too_long_args: Message::TOO_LONG_ARGS,
        unknown_command: Memo::Message::UNKNOWN_COMMAND
      }
      puts error_message_map[error_message_symbol]
      exit 2
    end
  end
end
