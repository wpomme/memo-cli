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
      when 'list'
        sub_parser(:list, argv: argv)
      when 'dirs'
        sub_parser(:dirs, argv: argv)
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
      when :list
        OptionParser.new do |opt|
          # 任意でDIR_NAMEを取る
          opt.on('-c', '--count', 'ファイル数を表示する')
        end
          .parse(argv)
      when :tags
        OptionParser.new do |opt|
          opt.on('-n', '--name', 'タグ名のみを表示する')
          opt.on('-c', '--count', 'タグ名とそのタグが付いているファイルの数を表示する')
        end
          .parse(argv)
      when :check
        OptionParser.new do |opt|
          opt.on('-d', '--duplicate', '重複したファイル名の情報を表示する')
          opt.on('-e', '--empty', 'タグの付いていないファイルの一覧を表示する')
        end
          .parse(argv)
      when :version
        puts Memo::VERSION
      else
        [sym, argv]
      end
    end
  end
end
