# frozen_string_literal: true

require 'rainbow'
require_relative 'memo_file_utility'

module Memo
  # Docsは廃止予定
  class Docs
    include Memo::MemoFileUtility

    #  memoディレクトリの中にあるファイルを操作するための情報を保存した値オブジェクト
    #  ファイルの読み取りに絶対パスを使ったり、ファイルの判定にファイル名を使用したりする。
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] filename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    Entry = Data.define(:full_path, :filename, :dir)

    class << self
      def list(memo_dir, dir = nil)
        if dir
          files_by_dir(memo_dir, dir)
        else
          files(memo_dir)
        end
      end

      def files(memo_dir)
        puts new(memo_dir).to_files
      end

      def files_by_dir(memo_dir, dir)
        files = new(memo_dir).to_files_by_dir(dir)
        unless files
          puts "#{dir}というディレクトリはありません。"
          exit(2)
        end
        puts files
      end
    end

    # Docsオブジェクトの新しいインスタンスを作成する。
    #
    # @param memo_dir [String] メモが保存されているディレクトリのパス
    # @param entries [Array<Entry>] 絶対パスなど、メモの中のファイルを読み取るための情報の値データオブジェクト
    # @param dir_set [Set<String>] メモの中のディレクトリの集合
    def initialize(memo_dir)
      @memo_dir = memo_dir
      @entries = load_entries
      @dir_set = Set.new(@entries.map(&:dir).uniq).freeze
    end

    # entryが空ならユーザーにメッセージを出してコマンドを終了する
    # entryが空でなければ、対象のメモを読み取ってその値を返す
    # TODO: 複数の場合も、エラーなどにする
    #
    # @param [Entry] or nil?
    # @return [<Array<String>>] 読み取ったメモが行ごとに保存されていて、さらに配列で包まれている。仕様上、複数のファイルを読み取る場合があるため。
    def read_a_file
      if @read_entry.nil?
        puts "#{@word} というメモはありません。"
        exit(2)
      end
      File.readlines(@read_entry.full_path, chomp: true)
    end

    def to_files_by_dir(dir)
      return unless grouped_by_dir(@entries).key?(dir)

      grouped_by_dir(@entries)[dir].map(&:filename)
    end

    # ディレクトリとその中に入っているメモファイルの配列を返す
    # dirをkeyにして、ファイルの配列を集合にしたもののハッシュを返却してもいいかも
    def to_files
      grouped_by_dir(@entries).map do |key, entries|
        [Rainbow(key).green, entries.map(&:filename)]
      end
    end

    private

    # memoディレクトリをDir.glob で探索して、その中のファイルを読み取るための情報を取得して、Entryに保存する
    #
    # @return [Array<Entry>] 絶対パスなど、メモの中のファイルを読み取るための情報の値データオブジェクト
    def load_entries
      Dir.glob("**/*.md", base: @memo_dir).filter_map do |rel_path|
        next if File.basename(rel_path) == 'README.md'

        full_path = File.join(@memo_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        dir = File.dirname(rel_path) == "." ? File.basename(@memo_dir) : File.dirname(rel_path)

        Entry.new(
          full_path: full_path,
          filename: filename(full_path),
          dir: dir
        )
      end
    end
  end
end
