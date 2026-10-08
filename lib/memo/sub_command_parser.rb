# frozen_string_literal: true

module Memo
  class SubCommandParser
    NIL_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('', '', '', '', nil, nil)
    HELP_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('help', '--help', '-h', 'memoコマンドのヘルプ', nil, nil)
    READ_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('read', '--read', '-r', '対象のメモを全文表示する', 'WORD', nil)
    LIST_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('list', '--list', '-l', 'メモの一覧を表示する', '[DIRS]', nil)
    DIRS_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('dirs', '--dirs', '-d', 'メモの中のディレクトリの一覧を表示する', nil, nil)
    SEARCH_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('search', '--search', '-s', '検索した文字列で全てのメモを全文検索する', 'WORD', nil)

    # memo tagsは引数ごとにさらにパースする必要がある
    TAGS_SUB_COMMAND_NAME_SPEC = Model::SubCommandSubSpec.new('name', '--name', '-n')
    TAGS_SUB_COMMAND_EMPTY_SPEC = Model::SubCommandSubSpec.new('empty', '--empty', '-e')
    TAGS_SUB_COMMAND_COUNT_SPEC = Model::SubCommandSubSpec.new('count', '--count', '-c')

    TAGS_SUB_COMMAND_SPEC_LIST = [TAGS_SUB_COMMAND_NAME_SPEC, TAGS_SUB_COMMAND_EMPTY_SPEC, TAGS_SUB_COMMAND_COUNT_SPEC].freeze

    TAGS_SUB_COMMAND_FIND = lambda do |tags_sub_commands, word|
      tags_sub_commands.filter_map do |spec|
        spec.to_sym(word)
      end
    end

    TAGS_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('tags', '--tags', '-t', 'タグ名とそのタグ名が付いたファイル名の一覧を表示する', '[FILTER]', proc do |filter|
      TAGS_SUB_COMMAND_FIND.call(TAGS_SUB_COMMAND_SPEC_LIST, filter)
    end)
    TAG_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('tag', '--tag', '-x', '与えらえたタグ名に対応するファイル名の一覧を表示する', 'TAG_NAME', nil)

    SUB_COMMAND_SPEC_LIST = [READ_COMMAND_SPEC, LIST_COMMAND_SPEC, DIRS_COMMAND_SPEC, SEARCH_COMMAND_SPEC, TAGS_COMMAND_SPEC, TAG_COMMAND_SPEC,
                             HELP_COMMAND_SPEC].freeze

    # 引数が登録されているサブコマンドであれば、そのサブコマンドの構造体SPECを返す
    #
    # @return [SUB_COMMAND_SPEC_LIST]
    SUB_COMMAND_FIND = lambda { |word|
      SUB_COMMAND_SPEC_LIST.find { |spec| spec.to_opts(word) }
    }

    def self.parse!(argv)
      argc = argv.length

      parsed_hash = {}

      case argc
        # 引数がゼロの場合はヘルプメッセージを表示する
      when 0
        return to_help_message(parser.help)
      when 1
        first = argv[0]

        parser

        found = SUB_COMMAND_FIND.call(first)

        if found.nil?
          # firstがどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
          parser.parse(['-r', first], into: parsed_hash)
        else
          # 引数が足りない場合は、エラーメッセージを表示する
          return to_error_message(:no_given_args, found) if found.required?

          # サブコマンドにヘルプを受け取った場合は、ヘルプメッセージを表示する
          return to_help_message(parser.help) if found[:short_form] == '-h'

          parser.parse([found[:short_form]], into: parsed_hash)
        end
      when 2
        first = argv[0]
        second = argv[1]

        parser

        found = SUB_COMMAND_FIND.call(first)

        # 最初の引数がサブコマンドでなければ、エラーメッセージを表示する
        return to_error_message(:unknown_command) if found.nil?

        if found[:parsed_block].nil?
          # 引数が多い場合は、エラーメッセージを表示する
          return to_error_message(:too_many_args, found) if found.no_args?

          parser.parse([found[:short_form], second], into: parsed_hash)
        else
          # foundにブロックが登録されている場合は、["--tags=--list"]のような形式に変換してからparse!に渡す
          parser.parse(["#{found[:long_form]}=#{second}"], into: parsed_hash)
        end
        # 引数が多い場合はエラーメッセージを表示する
      when (3..)
        return to_error_message(:too_many_args)
      else
        raise StandardError, 'There is something wrong with argv.size from SubCommandParser.parse!'
      end

      parsed_hash
    end

    def self.parser
      OptionParser.new do |opts|
        # ヘルプメッセージの登録を行う
        opts.banner = Memo::Message::OPT_BANNER
        Memo::Message::OPT_SEPARATOR_HEREDOCS.split("\n").each do |line|
          opts.separator line.sub('new_line', '')
        end

        # OptionParserにそれぞれのサブコマンドを登録する
        SUB_COMMAND_SPEC_LIST.each do |spec|
          long_form = spec.option_argv.nil? ? spec.long_form : spec.long_form_with_argv

          if spec.parsed_block.nil?
            opts.on(spec.short_form, long_form, spec.desc)
          else
            opts.on(spec.short_form, long_form, spec.desc, &spec.parsed_block)
          end
        end
      end
    end

    # ユーザーにヘルプメッセージを表示する
    #
    # @return [SystemExit]
    def self.to_help_message(message)
      puts message
      exit 0
    end

    # ユーザーにエラーメッセージを返す
    #
    # 主に引数が足りないときに使う
    # @return [SystemExit | ArgumentError]
    def self.to_error_message(symbol, found = NIL_COMMAND_SPEC)
      error_message_map = {
        no_given_args: Message::NO_GIVEN_ARGS.gsub('CLI', found[:sub_command_form]),
        too_many_args: Message::TOO_MANY_ARGS,
        unknown_command: Memo::Message::UNKNOWN_COMMAND
      }
      puts error_message_map[symbol]
      exit 2
    end

    private_class_method :to_help_message, :to_error_message
  end
end
