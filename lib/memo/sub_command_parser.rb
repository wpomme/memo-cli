# frozen_string_literal: true

module Memo
  class SubCommandParser
    HELP_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('help', '--help', '-h', 'memoコマンドのヘルプ', :none, nil, nil)
    READ_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('read', '--read', '-r', '対象のメモを全文表示する', :required, '--read WORD', proc do |word|
      [:read, word]
    end)
    LIST_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('list', '--list', '-l', 'メモの一覧を表示する', :optional, '--list [DIRS]', proc do |dirs|
      dirs ? [:list, dirs] : [:list]
    end)
    DIRS_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('dirs', '--dirs', '-d', 'メモの中のディレクトリの一覧を表示する', :none, nil, proc do
      [:dirs]
    end)
    SEARCH_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('search', '--search', '-s', '検索した文字列で全てのメモを全文検索する', :required, '--search WORD', proc do |word|
      [:search, word]
    end)

    # NOTE: on(pat = /*/)で置き換えられそう
    # ref: https://docs.ruby-lang.org/ja/latest/method/OptionParser/i/on.html
    TAGS_SUB_COMMANDS = {
      list: %w[-l --list],
      empty: %w[-e --empty],
      tally: %w[-t --tally]
    }.freeze

    TAGS_SUB_COMMAND_FIND = lambda { |tags_sub_commands, filter|
      tags_sub_commands.keys.find do |key|
        tags_sub_commands[key].include?(filter)
      end
    }

    TAGS_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('tags', '--tags', '-t', 'タグ名とそのタグ名が付いたファイル名の一覧を表示する', :sub_option, '--tags [FILTER]', proc do |filter|
      found = TAGS_SUB_COMMAND_FIND.call(TAGS_SUB_COMMANDS, filter)

      found ? [:tags, found] : [:tags]
    end)
    TAG_COMMAND_SPEC = Memo::Model::SubCommandSpec.new('tag', '--tag', '-x', '与えらえたタグ名に対応するファイル名の一覧を表示する', :required, '--tag TAG_NAME', proc do |tag_name|
      [:tag, tag_name]
    end)

    SUB_COMMANDS_SPEC = [READ_COMMAND_SPEC, LIST_COMMAND_SPEC, DIRS_COMMAND_SPEC, SEARCH_COMMAND_SPEC, TAGS_COMMAND_SPEC, TAG_COMMAND_SPEC,
                         HELP_COMMAND_SPEC].freeze

    # 引数が登録されているサブコマンドであれば、そのサブコマンドの構造体SPECを返す
    #
    # @return [SUB_COMMANDS_SPEC]
    SUB_COMMAND_FIND = lambda { |word|
      SUB_COMMANDS_SPEC.find { |spec| spec.to_opts(word) }
    }

    def self.parse!(argv)
      first = argv.shift

      parser

      found = SUB_COMMAND_FIND.call(first)

      # 引数がゼロの場合、ヘルプメッセージを表示する
      parser.parse!(['-h']) if first.nil?

      parsed_hash = {}

      if found.nil?
        # firstがどのサブコマンドにも当てはまらなかった場合、memo <word>として処理する
        parser.parse!(['-r'] + [first], into: parsed_hash)

        return parsed_hash[:read]
      else
        return to_error_message(found, :no_given_args) if found[:argv_type] == :required && argv.empty?

        if found[:argv_type] == :sub_option && !argv.first.nil?
          # ["--tags=--list"]のような形式に変換してからparse!に渡す
          parser.parse!(["#{found[:long_form]}=#{argv.first}"], into: parsed_hash)
        else
          parser.parse!([found[:short_form], argv.first], into: parsed_hash)
        end
      end

      # TODO: 配列からハッシュを返すようにテストコードや実装を変更する
      parsed_hash[found[:sub_command_form].intern]
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
  end
end
