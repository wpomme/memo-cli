# frozen_string_literal: true

module Memo
  class SubCommandParser
    HELP_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('help', '--help', '-h', 'memoコマンドのヘルプ', nil, nil)
    READ_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('read', '--read', '-r', '対象のメモを全文表示する', 'WORD', nil)
    LIST_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('list', '--list', '-l', 'メモの一覧を表示する', '[DIRS]', nil)
    DIRS_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('dirs', '--dirs', '-d', 'メモの中のディレクトリの一覧を表示する', nil, nil)
    SEARCH_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('search', '--search', '-s', '検索した文字列で全てのメモを全文検索する', 'WORD', nil)

    # memo tagsは引数ごとにさらにパースする必要がある
    TAGS_SUB_COMMAND_LIST_SPEC = Model::SubCommandSubSpec.new('list', '--list', '-l')
    TAGS_SUB_COMMAND_EMPTY_SPEC = Model::SubCommandSubSpec.new('empty', '--empty', '-e')
    TAGS_SUB_COMMAND_TALLY_SPEC = Model::SubCommandSubSpec.new('tally', '--tally', '-t')

    TAGS_SUB_COMMANDS_SPEC = [TAGS_SUB_COMMAND_LIST_SPEC, TAGS_SUB_COMMAND_EMPTY_SPEC, TAGS_SUB_COMMAND_TALLY_SPEC].freeze

    TAGS_SUB_COMMAND_FIND = lambda do |tags_sub_commands, word|
      tags_sub_commands.filter_map do |spec|
        spec.to_sym(word)
      end
    end

    TAGS_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('tags', '--tags', '-t', 'タグ名とそのタグ名が付いたファイル名の一覧を表示する', '[FILTER]', proc do |filter|
      TAGS_SUB_COMMAND_FIND.call(TAGS_SUB_COMMANDS_SPEC, filter)
    end)
    TAG_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('tag', '--tag', '-x', '与えらえたタグ名に対応するファイル名の一覧を表示する', 'TAG_NAME', nil)

    SUB_COMMANDS_SPEC = [READ_COMMAND_SPEC, LIST_COMMAND_SPEC, DIRS_COMMAND_SPEC, SEARCH_COMMAND_SPEC, TAGS_COMMAND_SPEC, TAG_COMMAND_SPEC,
                         HELP_COMMAND_SPEC].freeze

    # 引数が登録されているサブコマンドであれば、そのサブコマンドの構造体SPECを返す
    #
    # @return [SUB_COMMANDS_SPEC]
    SUB_COMMAND_FIND = lambda { |word|
      SUB_COMMANDS_SPEC.find { |spec| spec.to_opts(word) }
    }

    def self.parse!(argv)
      first = argv[0]

      parser

      found = SUB_COMMAND_FIND.call(first)

      # 引数がゼロの場合、ヘルプメッセージを表示する
      parser.parse!(['-h']) if first.nil?

      parsed_hash = {}

      if found.nil?
        # firstがどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
        parser.parse!(['-r', first], into: parsed_hash)
      else
        second = argv[1]

        return to_error_message(found, :no_given_args) if found.required? && second.nil?

        if found[:parsed_block].nil?
          parser.parse!([found[:short_form], second], into: parsed_hash)
        else
          # ["--tags=--list"]のような形式に変換してからparse!に渡す
          parser.parse!(["#{found[:long_form]}=#{second}"], into: parsed_hash)
        end
      end

      parsed_hash
    end

    def self.parser
      OptionParser.new do |opts|
        opts.banner = Memo::Message::OPT_BANNER
        Memo::Message::OPT_SEPARATOR_HEREDOCS.split("\n").each do |line|
          opts.separator line.sub('new_line', '')
        end

        # OptionParserにそれぞれのサブコマンドを登録する
        SUB_COMMANDS_SPEC.each do |spec|
          if spec.sub_command_form == 'help'
            # helpコマンドを呼び出したときの処理がopts.on_tailのブロックに記載がある。
            opts.on(spec.short_form, spec.long_form, spec.desc) do
              puts opts.help
              exit 0
            end
          elsif spec.parsed_block.nil?
            long_form = spec.option_argv.nil? ? spec.long_form : spec.long_form_with_argv

            opts.on(spec.short_form, long_form, spec.desc)
          else
            opts.on(spec.short_form, spec.long_form_with_argv, spec.desc, &spec.parsed_block)
          end
        end
      end
    end

    # ユーザーにエラーメッセージを返す
    #
    # 主に引数が足りないときに使う
    # @return [String]
    def self.to_error_message(found, symbol)
      error_message_map = {
        no_given_args: Message::NO_GIVEN_ARGS.gsub('CLI', found[:sub_command_form])
      }
      puts error_message_map[symbol]
      exit 2
    end

    private_class_method :to_error_message
  end
end
