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

    # ファイル名の一覧をViewに渡す前に加工するための関数
    #
    # @return [Array | String]
    def file_list_to_view(dir = nil)
      grouped_file_list = @repo.grouped_file_list

      if dir
        ret = grouped_file_list.filter_map { |grouped| grouped.to_view(dir) }

        ## dir が存在する場合
        return ret unless ret.empty?

        ## dir が存在しない場合は、ユーザーに表示するメッセージを返す
        Memo::Message::NO_DIRECTORIES.sub('dir', dir) << colored_dirs.join(' ')
      else
        grouped_file_list.map(&:to_view)
      end
    end

    # file_list_to_viewを置き換えるために作成
    # ファイル名の一覧をViewに渡す前に加工するための関数
    #
    # @return [Array | String]
    def file_list_hash_to_view(dir = nil)
      grouped_file_list_hash = @repo.grouped_file_list_hash

      if dir
        if grouped_file_list_hash[dir].nil?
          ## dirが存在しない場合は、その旨をユーザーに表示するメッセージを返す
          Memo::Message::NO_DIRECTORIES.sub('dir', dir) << @repo.dir_set.join(' ')
        else
          ## dirが存在する場合は、該当のディレクトリに色付けをして、それに紐付くファイル名のリストを返す
          grouped_file_list_hash[dir].map do |filename|
            (ret ||= [Rainbow(dir).green]) << filename
            ret
          end
        end
      else
        grouped_file_list_hash.each do |dir, filenames|
          [Rainbow(dir).green].concat(filenames)
        end
      end
    end
  end
end
