# frozen_string_literal: true

module Memo
  # ファイルやディレクトリパスの操作に関するユーティリティモジュール
  # TODO: Utilityにリネームする
  module FileUtility
    # ファイルパスから、そのファイルのファイル名を返す
    #
    # @param [String] file_path 対象のファイルのファイルパス
    # @return [String] ファイル名
    def filename(file_path)
      File.basename(file_path, '.md')
    end
  end
end
