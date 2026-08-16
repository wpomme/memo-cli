# frozen_string_literal: true

module Memo
  module Service
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
      prompt_hash = {}
      choices.each_key.with_index do |key, index|
        prompt_hash[index + 1] = key
      end

      print_prompt(title: title, prompt_hash: prompt_hash)
      input = gets.chomp.to_i

      if input.between?(1, choices.length)
        choices[prompt_hash[input]]
      else
        select_prompt(title: title, choices: choices)
      end
    end

    private

    # select_promptから標準出力に表示する文字列を抽出した関数
    #
    # @params title [String]
    # @params prompt_hash [Hash]
    def print_prompt(title:, prompt_hash:)
      puts title
      prompt_hash.each_key do |key|
        puts "[#{key}] #{prompt_hash[key]}"
      end
    end
  end
end
