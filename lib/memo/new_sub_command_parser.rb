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
      when 'read'
        sub_parser(:read, argv: argv)
      when 'search'
        sub_parser(:search, argv: argv)
      when 'dirs'
        sub_parser(:dirs, argv: argv)
      when 'list'
        sub_parser(:list, argv: argv)
      when 'tags'
        sub_parser(:tags, argv: argv)
      when 'tag'
        sub_parser(:tag, argv: argv)
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

    def sub_parser(sym, argv: nil)
      case sym
      when :search
        to_error_message(:no_given_args, :search) if argv.empty?

        to_error_message(:too_many_args, :search) if argv.size > 1

        { search: argv[0] }
      when :read
        to_error_message(:no_given_args, :read) if argv.empty?

        to_error_message(:too_many_args, :read) if argv.size > 1

        { read: argv[0] }
      when :dirs
        to_error_message(:too_many_args, :dirs) unless argv.empty?

        { dirs: true }
      when :list
        to_error_message(:no_given_args, :list) if argv.empty?

        to_error_message(:too_many_args, :list) if argv.size > 1

        # argv[0].match(/\A([\w\/¥])\Z/)

        # { list: }

        # OptionParser.new do |opt|
        #   # 任意でDIR_NAMEを取る
        #   opt.on('-c', '--count', 'ファイル数を表示する')
        # end
        #   .parse(argv)
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
      when :version
        puts Memo::VERSION
      else
        [sym, argv]
      end
    end

    private

    def to_error_message(error_message_symbol, sub_command_symbol)
      dispatch = {
        read: 'read',
        search: 'search',
        dirs: 'dirs'
      }
      error_message_map = {
        no_given_args: Message::NO_GIVEN_ARGS.gsub('CLI', dispatch[sub_command_symbol]),
        too_many_args: Message::TOO_MANY_ARGS.gsub('CLI', dispatch[sub_command_symbol]),
        unknown_command: Memo::Message::UNKNOWN_COMMAND
      }
      puts error_message_map[error_message_symbol]
      exit 2
    end
  end
end
