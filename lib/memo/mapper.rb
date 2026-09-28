# frozen_string_literal: true

module Memo
  class Mapper
    INDENT = " "

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

    # タグ名の一覧を返す
    #
    # @return [String]
    def tag_list_to_view
      @repo.tag_list.join("\n")
    end

    # 色付けしたタグ名とそのタグが付いたファイル名の一覧を返す
    #
    # @return [String]
    def tag_and_filenames_to_view
      seeds_hash_to_view(@repo.tag_seeds_hash, :aqua)
    end

    # 対象のメモフォルダの中にあるディレクトリ一覧を表示用に変換する
    #
    # return [String]
    def dirs_to_view
      @repo.dir_set.join(INDENT)
    end

    # 指定されたディレクトリについて、そのディレクトリの中にあるディレクトリとファイル名を返す関数
    # Viewに渡す前に、ディレクトリ名には色付けをする
    #
    # @return [Array<String> | String]
    def grouped_ls_to_view(dir = nil)
      dir_set = @repo.dir_set
      grouped_ls = @repo.grouped_ls

      if dir
        return Memo::Message::NO_DIRECTORIES.sub('dir', dir) << dirs_to_view unless dir_set.include?(dir)

        [Rainbow(dir).green].concat(grouped_ls[dir].map(&:basename))
      else
        seeds_hash_to_view(grouped_ls, :green)
      end
    end

    private

    def seeds_hash_to_view(seeds_hash, color_symbol)
      seeds_hash.inject([]) do |result, (key, seeds)|
        result << Rainbow(key).color(color_symbol)
        filenames = seeds.map(&:basename).join(INDENT)
        result << filenames
      end
    end
  end
end
