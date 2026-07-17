# frozen_string_literal: true

module Memo
  # ファイルやディレクトリパスの操作に関するユーティリティモジュール
  module MemoFileUtility
    # TODO: このEntryはこちらに移動させたい
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] filename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # Entry = Data.define(:full_path, :filename, :dir)

    # protected
    #
    # ディレクトリの集合を配列に変換する
    #
    # @param [Set<String>] memoフォルダの配下にあるディレクトリの集合
    # @return [Array<String>] memoフォルダの配下にあるディレクトリの一覧を配列で返す
    def self.to_dirs(dir_set)
      dir_set.to_a
    end

    # dir をkey としてentry をHash 化したもの
    #
    # ?? @param [Array<Entry>]
    def self.grouped_by_dir(entries)
      entries.group_by(&:dir)
    end

    # ファイルパスから、そのファイルのファイル名を返す
    #
    # @param [String] file_path 対象のファイルのファイルパス
    # @return [String] ファイル名
    def self.filename(file_path)
      File.basename(file_path, '.md')
    end
  end
end
