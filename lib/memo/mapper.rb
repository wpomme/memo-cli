# frozen_string_literal: true

require 'rainbow'

module Memo
  class Mapper
    def initialize(dir = Memo::Env.memo_dir)
      @memo_dir = dir
    end

    # ファイル名の一覧をViewに渡す前に加工するための関数
    # ディレクトリ名に色を付けるのは、GroupedFileListのStructのブロックで定義するのもありかもしれない
    #
    # @return [Array | String] NOTE: ユーザーメッセージの方はもう少しなんとかしたい
    def file_list_to_view(dir = nil)
      ## REVIEW: コードの重複を避けたい
      repo = Memo::Repository.new(@memo_dir)
      seeds = repo.seeds

      if dir
        ret = Memo::Model.new.grouped_file_list(seeds).filter_map do |struct|
          [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n") if struct[:dir] == dir
        end.flatten
        ret.pop

        ## dir が存在する場合
        return ret unless ret.empty?

        ## dir が存在しない場合は、ユーザーに表示するメッセージを返す
        ## TODO: Mapper#colored_dirsを作成する
        colored_dirs = repo.to_dirs.map { |dir| Rainbow(dir).green }
        return <<~NOT_DIR
          #{dir}というディレクトリはありませんでした。
          ディレクトリの一覧は次の通りです。
          #{colored_dirs.join(' ')}
        NOT_DIR
      end

      ret = Memo::Model.new.grouped_file_list(seeds).map do |struct|
        [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
      end.flatten
      ret.pop
      ret
    end
  end
end
