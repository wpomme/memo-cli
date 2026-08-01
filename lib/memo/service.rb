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
  end
end
