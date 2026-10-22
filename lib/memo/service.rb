# frozen_string_literal: true

module Memo
  module Service
    module_function

    # マークダウンファイルについて、yaml形式で書かれたfront matterをパースする
    #
    # @params markdown[String]
    # @return [Hash<String, Object>]
    def parse_yaml_front_matter(markdown)
      return {} unless markdown =~ /\A(---\s*\n.*?\n?)^---\s*$\n?/m

      front_matter_yaml = ::Regexp.last_match(1)

      YAML.safe_load(front_matter_yaml, permitted_classes: [Time])
    end

    # ターミナルに表示するタイトルと選択肢のハッシュを受け取り、選択したキーの値を返す
    # 選択したキーが無効であれば、もう一度やり直す
    #
    # @params title [String]
    # @params choices [Hash]
    def select_prompt(title:, choices:)
      choice_keys = choices.keys

      print_prompt(title: title, choice_keys: choice_keys)

      begin
        input = gets.chomp.to_i

        if input.between?(1, choices.length)
          choices[choice_keys[input - 1]]
        else
          select_prompt(title: title, choices: choices)
        end
      rescue Interrupt
        puts Memo::Message::INTERRUPT_PROMPT
        exit 0
      end
    end

    # select_promptから標準出力に表示する文字列を抽出した関数
    #
    # @params title [String]
    # @params choice_keys [Array]
    def print_prompt(title:, choice_keys:)
      puts title
      choice_keys.each.with_index(1) do |key, index|
        puts "[#{index}] #{key}"
      end
    end
  end
end
