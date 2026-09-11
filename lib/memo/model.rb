# frozen_string_literal: true

module Memo
  module Model
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #
    # @!attribute [w] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [w] rel_path
    #   @return [String] 対象のディレクトリからそのファイルへのパス
    # @!attribute [w] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # @!attribute [w] filename
    #   @return [String] 対象のファイルのファイル名
    Seed = Data.define(:full_path, :rel_path, :dir, :filename)

    DirSeed = Struct.new(:basename, :parent_dir, :dir) do
      def initialize(target_dir, root_dirname)
        if target_dir == root_dirname
          super(File.basename(target_dir), nil, target_dir)
        else
          parent_dir = File.dirname(target_dir)

          super(File.basename(target_dir), parent_dir == "." ? root_dirname : parent_dir, target_dir)
        end
      end
    end

    # 対象のディレクトリの中にあるファイル名の配列を保存する
    # :dirは文字列、:filenamesは文字列の配列が入る
    GroupedFileList = Struct.new(:dir, :filenames) do
      def initialize(...)
        super
        freeze
      end

      def to_view(target_dir = nil)
        if target_dir
          [Rainbow(dir).green] + filenames if dir == target_dir
        else
          [Rainbow(dir).green] + filenames
        end
      end
    end

    # 対象のディレクトリを文字列で検索してヒットしたときに返す値
    SearchLine = Struct.new(:path, :line_number, :line) do
      def initialize(...)
        super
        freeze
      end

      def to_view(word)
        "#{path}:#{line_number}:#{line.sub(word, Rainbow(word).red)}"
      end
    end
  end
end
