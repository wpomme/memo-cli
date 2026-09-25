# frozen_string_literal: true

require 'rainbow'

module Memo
  class Mapper
    def initialize(repo)
      @repo = repo
    end

    # 検索でヒットした文字列に色をつける
    #
    # @param word [string]
    # @return [Array<String>, String]
    def search_result_to_view(word)
      search_result = @repo.search_all(word)

      # 検索結果が空だった場合は、その旨を示すメッセージを表示する
      return Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', word) if search_result.all?(&:empty?)

      search_result.flatten.map do |line|
        line.to_view(word)
      end
    end

    # memo_dirの中にあるディレクトリに色をつける
    # return [Array<>]
    def colored_dirs
      @repo.dir_set.to_a.map { |dir| Rainbow(dir).green }
    end

    # 指定されたディレクトリについて、そのディレクトリの中にあるディレクトリとファイル名を返す関数
    # Viewに渡す前に、ディレクトリ名には色付けをする
    #
    # @return [Array<String> | String]
    def grouped_ls_to_view(dir = nil)
      dir_set = @repo.dir_set
      grouped_ls = @repo.grouped_ls

      if dir
        return Memo::Message::NO_DIRECTORIES.sub('dir', dir) << dir_set.join(' ') unless dir_set.include?(dir)

        [Rainbow(dir).green].concat(grouped_ls[dir].map(&:basename))
      else
        grouped_ls.inject([]) do |result, (dir, seeds)|
          result << Rainbow(dir).green
          result.concat(seeds.map(&:basename))
        end
      end
    end
  end
end
