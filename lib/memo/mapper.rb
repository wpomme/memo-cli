# frozen_string_literal: true

require 'rainbow'

module Memo
  class Mapper
    include Memo::Model

    def initialize(repo)
      @repo = repo
    end

    # memo_dirの中にあるディレクトリに色をつける
    # return [Array<>]
    def colored_dirs
      @repo.to_dirs.map { |dir| Rainbow(dir).green }
    end

    # ファイル名の一覧をViewに渡す前に加工するための関数
    # ディレクトリ名に色を付けるのは、GroupedFileListのStructのブロックで定義するのもありかもしれない
    #
    # @return [Array | String] NOTE: ユーザーメッセージの方はもう少しなんとかしたい
    def file_list_to_view(dir = nil)
      seeds = @repo.seeds

      if dir
        ret = grouped_file_list(seeds).filter_map do |struct|
          [Rainbow(struct[:dir]).green] + struct[:filenames] if struct[:dir] == dir
        end

        ## dir が存在する場合
        return ret unless ret.empty?

        ## dir が存在しない場合は、ユーザーに表示するメッセージを返す
        return <<~NOT_DIR
          #{dir}というディレクトリはありませんでした。
          ディレクトリの一覧は次の通りです。
          #{colored_dirs.join(' ')}
        NOT_DIR
      end

      grouped_file_list(seeds).map do |struct|
        [Rainbow(struct[:dir]).green] + struct[:filenames]
      end
    end
  end
end
