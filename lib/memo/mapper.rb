# frozen_string_literal: true

require 'rainbow'

module Memo
  class Mapper
    # ファイル名の一覧をViewに渡す前に加工するための関数
    # ディレクトリ名に色を付けるのは、GroupedFileListのStructのブロックで定義するのもありかもしれない
    #
    # @return [Array | String] NOTE: ユーザーメッセージの方はもう少しなんとかしたい
    def self.file_list_to_view(memo_dir, dir = nil)
      ## REVIEW: コードの重複を避けたい
      seeds = Memo::Repository.new(memo_dir).seeds

      if dir
        ret = Memo::Model.new.grouped_file_list(seeds).filter_map do |struct|
          [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n") if struct[:dir] == dir
        end.flatten
        ret.pop

        ## dir が存在する場合
        return ret unless ret.empty?

        ## dir が存在しない場合は、ユーザーに表示するメッセージを返す
        colored_dirs = Memo::Repository.new(memo_dir).to_dirs.map { |dir| Rainbow(dir).green }
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
