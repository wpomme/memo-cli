# frozen_string_literal: true

require 'rainbow'

module Memo
  class ViewModel
    def self.file_list_to_presenter(memo_dir, dir = nil)
      ## REVIEW: コードの書きっぷりが情けないほどダブってるので描き直したい
      if dir
        ret = Memo::Repository.new(memo_dir).grouped_file_list.filter_map do |struct|
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

      ret = Memo::Repository.new(memo_dir).grouped_file_list.map do |struct|
        [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
      end.flatten
      ret.pop
      ret
    end
  end
end
