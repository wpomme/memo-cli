# frozen_string_literal: true

module Memo
  module Structure
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #  NOTE: Loaderのfile_seedに使えるかもしれない
    #
    # @!attribute [r] target_dir
    #   @return [String] このSeedがどのtarget_dirから読み込まれているかを示す値
    # @!attribute [r] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [r] parent_dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # @!attribute [r] relative_path
    #   @return [String] 対象のディレクトリからそのファイルへのパス
    # @!attribute [r] filename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [r] tags
    #   @return [Array<String>] 対象のファイルのフロントマター部分のtagsの値
    FileSeed = Struct.new(:target_dir, :absolute_path, :parent_directory, :relative_path, :filename, :file_content, :tags) do
      def initialize(...)
        super
        freeze
      end
    end

    # FileSeedを使うならこちも使う
    # NOTE: target_dir => target_directory, parent_rel_path => relative_pathに変更したい
    DirectorySeed = Struct.new(:target_dir, :absolute_path, :relative_path) do
      def initialize(...)
        super
        freeze
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
