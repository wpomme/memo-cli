# frozen_string_literal: true

module Memo
  # 対象のディレクトリの中にあるファイル名の配列を保存する
  # TODO: Struct.newの第一引数に文字列を渡してクラスに名前を付ける
  # :dirは文字列、:filenamesは文字列の配列が入る
  GroupedFileList = Struct.new(:dir, :filenames)
end
