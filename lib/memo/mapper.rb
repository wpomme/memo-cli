# frozen_string_literal: true

require 'rainbow'

module Memo
  class Mapper
    include Memo::Model

    def initialize(repo)
      @repo = repo
    end

    # 検索でヒットした文字列に色をつける
    #
    # @param word [string]
    # @return [Array<string>, String]
    def search_result_to_view(word)
      # TODO: ユーザーメッセージを集約化する
      not_found_message = "#{word}で全ファイル検索しましたが、そのような文字列は見当たりませんでした。"

      search_result = @repo.search_all(word)
      return not_found_message if search_result.nil?

      search_result.flatten.map do |line|
        line.to_view(word)
      end
    end

    # memo_dirの中にあるディレクトリに色をつける
    # return [Array<>]
    def colored_dirs
      @repo.to_dirs.map { |dir| Rainbow(dir).green }
    end

    # ファイル名の一覧をViewに渡す前に加工するための関数
    #
    # @return [Array | String]
    def file_list_to_view(dir = nil)
      seeds = @repo.seeds

      if dir
        ret = grouped_file_list(seeds).filter_map { |grouped| grouped.to_view(dir) }

        ## dir が存在する場合
        return ret unless ret.empty?

        ## dir が存在しない場合は、ユーザーに表示するメッセージを返す
        return <<~NOT_DIR
          #{dir}というディレクトリはありませんでした。
          ディレクトリの一覧は次の通りです。
          #{colored_dirs.join(' ')}
        NOT_DIR
      end

      grouped_file_list(seeds).map(&:to_view)
    end
  end
end
