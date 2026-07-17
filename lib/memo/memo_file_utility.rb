# frozen_string_literal: true

module Memo
  # ファイルやディレクトリパスの操作に関するユーティリティモジュール
  module MemoFileUtility
    protected

    # dir をkey としてentry をHash 化したもの
    #
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
