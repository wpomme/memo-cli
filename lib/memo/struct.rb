# frozen_string_literal: true

module Memo
  # 対象のディレクトリの中にあるファイル名とフルパスの配列を保存する
  # :dirは文字列、:file_hashはファイル名がキーで絶対パスが値となるHashが入る
  GroupedFileList = Struct.new(:dir, :file_hash)
end
