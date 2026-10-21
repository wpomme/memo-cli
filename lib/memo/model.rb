# frozen_string_literal: true

module Memo
  module Model
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #  NOTE: Loaderのfile_seedに使えるかもしれない
    #
    # @!attribute [w] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [w] rel_path
    #   @return [String] 対象のディレクトリからそのファイルへのパス
    # @!attribute [w] target_dir
    #   @return [String] このSeedがどのtarget_dirから読み込まれているかを示す値
    # @!attribute [w] parent_dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # @!attribute [w] basename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [w] tags
    #   @return [Array<String>] 対象のファイルのフロントマター部分のtagsの値
    Seed = Struct.new(:full_path, :rel_path, :target_dir, :parent_dir, :basename, :tags) do
      def initialize(...)
        super
        freeze
      end

      def directory?
        FileTest.directory?(full_path)
      end

      def file?
        FileTest.file?(full_path)
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
