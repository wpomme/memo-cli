# frozen_string_literal: true

module Memo
  # ファイルやディレクトリパスの操作に関するユーティリティモジュール
  module MemoFileUtility
    # dir をkey としてentry をHashとしたもの
    # 返り値がHashであることは検証済み
    #
    # @param [Array<Entry>]
    # @return [Hash<String, Entry>] <= yardの書き方が分からない。 キーがディレクトリで、値がEntryの配列
    def entries_grouped_by_dir(entries)
      entries.group_by(&:dir)
    end

    # dir をkey としてentry をHashとしたもの
    # 返り値がHashであることは検証済み
    #
    # @deprecate entries_grouped_by_dirを使う
    # @param [Array<Entry>]
    # @return [Hash] キーが文字列で、値がEntryの配列
    def grouped_by_dir(entries)
      entries.group_by(&:dir)
    end

    # ファイルパスから、そのファイルのファイル名を返す
    #
    # @param [String] file_path 対象のファイルのファイルパス
    # @return [String] ファイル名
    def filename(file_path)
      File.basename(file_path, '.md')
    end
  end
end
