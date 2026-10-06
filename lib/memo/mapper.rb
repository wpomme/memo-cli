# frozen_string_literal: true

module Memo
  class Mapper
    INDENT = ' '

    def initialize(repo)
      @repo = repo
    end

    # 検索でヒットした文字列に色をつける
    #
    # @param word [string]
    # @return [Array<String>, String]
    def search_result_to_view(word = '')
      return Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'search') if word.empty?

      search_result = @repo.search(word)

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

    # タグの付いていないファイル名の一覧をそのディレクトリと共に返す
    # 全てのファイルにタグ付けされていたら、その旨を知らせる文字列を返す
    #
    # @return [Array<String> | String]
    def empty_tags_file_list_to_view
      empty_tags_file_list = @repo.empty_tags_file_list

      return Memo::Message::NO_EMPTY_TAGS_FILE_LIST if empty_tags_file_list.empty?

      grouped = empty_tags_file_list.group_by(&:parent_dir)

      seeds_hash_to_view(grouped, :green)
    end

    def count_of_each_tag_to_view
      @repo.count_of_each_tag.map { |(first, last)| "#{first}\t#{last}" }
    end

    # 引数としてタグ名を取り、そのタグ名と紐付いているファイル名の一覧を返す
    # 引数として与えられたタグが存在しなければ、その旨を知らせる文字列を返す
    #
    # @param tag [String]
    # @return [String]
    def tag_and_filenames_by_tag_to_view(tag = '')
      tag_list = @repo.tag_list
      tag_seeds_hash = @repo.tag_seeds_hash

      return Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'tag') if tag.empty?

      if tag_list.include?(tag)
        seeds_hash_by_key_to_view(tag_seeds_hash, tag, :aqua)
      else
        Message::NO_TAGS.sub('tag', tag) << tag_list.join(INDENT)
      end
    end

    # 色付けしたタグ名とそのタグが付いたファイル名の一覧を返す
    #
    # @return [Array<String>]
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

        seeds_hash_by_key_to_view(grouped_ls, dir, :green)
      else
        seeds_hash_to_view(grouped_ls, :green)
      end
    end

    # グループ化されたSeedのハッシュについて、グループごとのファイル名を文字列にして返す
    #
    # @param seeds_hash [Hash<String, Array<Seed>>] 文字列がキーで、値がSeedの配列となるハッシュ
    # @param color_symbol [Symbol] キーの色付けを指定する
    # @return [Array<String>]
    def seeds_hash_to_view(seeds_hash, color_symbol)
      seeds_hash.inject([]) do |result, (key, seeds)|
        # NOTE: 次のコードでも動作する。使用するかどうか検討中
        # result.concat(seeds_hash_by_key_to_view(seeds_hash, key, color_symbol))
        result << Rainbow(key).color(color_symbol) << seeds.map(&:basename).join(INDENT)
      end
    end

    # NOTE: keyとそれに対応するseedsを渡した方がパフォーマンスが良さそう
    def seeds_hash_by_key_to_view(seeds_hash, key, color_symbol)
      return [] if seeds_hash.empty?

      [Rainbow(key).color(color_symbol)] << seeds_hash[key].map(&:basename).join(INDENT)
    end
  end
end
