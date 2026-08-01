# frozen_string_literal: true

module Memo
  module Model
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #  TODO: 読み取り専用にする
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] rel_path
    #   @return [String] 対象のディレクトリからそのファイルへのパス
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # @!attribute [rw] filename
    #   @return [String] 対象のファイルのファイル名
    Seed = Data.define(:full_path, :rel_path, :dir, :filename)

    # 対象のディレクトリの中にあるファイル名の配列を保存する
    # :dirは文字列、:filenamesは文字列の配列が入る
    GroupedFileList = Struct.new("GroupedFileList", :dir, :filenames) do
      def to_view(target_dir = nil)
        if target_dir
          [Rainbow(dir).green] + filenames if dir == target_dir
        else
          [Rainbow(dir).green] + filenames
        end
      end
    end

    # 対象のディレクトリを文字列で検索してヒットしたときに返す値
    SearchLine = Struct.new("SearchLine", :path, :line_number, :line) do
      def to_view(word)
        "#{path}:#{line_number}:#{line.sub(word, Rainbow(word).red)}"
      end
    end
  end
end
