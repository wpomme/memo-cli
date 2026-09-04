# frozen_string_literal: true

module Memo
  module Service
    module_function

    # 受け取ったSeedにしたがい、そのSeedの元となったファイルを全文表示する。
    #
    # @param [Seed]
    # @return [Array<String>] ファイルの全文を文字列型の一次元配列で返す
    def read(seed)
      File.readlines(seed.full_path, chomp: true)
    end

    # ファイルごとに引数のwordで行ごとに検索する
    #
    # wordが含まれている行の情報をSearchLineの一次元配列として返す
    # そのファイルにwordが含まれていなければ空の配列を返す
    # @params seed [Seed]
    # @params word [String]
    # @return [Array<SearchLine>, Array]
    def search(seed, word)
      File.readlines(seed.full_path, chomp: true)
        .each_with_index
        .filter_map do |line, index|
          Memo::Model::SearchLine.new(path: seed.rel_path, line_number: index + 1, line: line) if line.include?(word)
        end
    end

    # ターミナルに表示するタイトルと選択肢のハッシュを受け取り、選択したキーの値を返す
    # 選択したキーが無効であれば、もう一度やり直す
    #
    # @params title [String]
    # @params choices [Hash]
    def select_prompt(title:, choices:)
      choice_keys = choices.keys

      print_prompt(title: title, choice_keys: choice_keys)
      input = gets.chomp.to_i

      if input.between?(1, choices.length)
        choices[choice_keys[input - 1]]
      else
        select_prompt(title: title, choices: choices)
      end
    end

    # select_promptから標準出力に表示する文字列を抽出した関数
    #
    # @params title [String]
    # @params choice_keys [Array]
    def print_prompt(title:, choice_keys:)
      puts title
      choice_keys.each_with_index do |key, index|
        puts "[#{index + 1}] #{key}"
      end
    end
  end
end
