# frozen_string_literal: true

module Memo
  class Model
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #  Repositoryの内部で使用するため、Memo::Model::Seedとして使用する
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] filename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    Seed = Data.define(:full_path, :filename, :dir)

    # 対象のディレクトリの中にあるファイル名の配列を保存する
    # TODO: Struct.newの第一引数に文字列を渡してクラスに名前を付ける
    # :dirは文字列、:filenamesは文字列の配列が入る
    GroupedFileList = Struct.new(:dir, :filenames)
  end
end
