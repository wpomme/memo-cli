# frozen_string_literal: true

require 'rainbow'

module Memo
  class Docs
    ## TODO: { |entry| filename(entry.full_path) }やfilename(entry.full_path)のパターンが多い
    ## Entryにfilenameの情報を持たせた方がいい
    ## Entryをnotesかmemoにリネームする

    # memoディレクトリの中にあるファイルについての値オブジェクト
    # 絶対パスなど、そのファイルを読み取ったり、探したりするのに使う
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    Entry = Data.define(:full_path, :dir)

    class << self
      def dirs(memo_dir)
        puts new(memo_dir).to_dirs
      end

      def read(memo_dir, word)
        puts new(memo_dir).find_a_file(word).read_a_file
      end

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
      @dir_set = Set.new(@entries.map(&:dir).uniq)
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

    # チェーンメソッドにするためにselfを返している
    # やめた方がいいかもしれない
    def find_a_file(word)
      @word = word
      @read_entry = @entries.find { |entry| filename(entry.full_path) == word }
      self
    end

    def to_files_by_dir(dir)
      return unless grouped_by_dir.key?(dir)

      grouped_by_dir[dir].map { |entry| filename(entry.full_path) }
    end

    # ディレクトリとその中に入っているメモファイルの配列を返す
    # dirをkeyにして、ファイルの配列を集合にしたもののハッシュを返却してもいいかも
    def to_files
      grouped_by_dir.map do |key, entries|
        [Rainbow(key).green, entries.map { |entry| filename(entry.full_path) }]
      end
    end

    # ディレクトリの集合を配列に変換する
    #
    # @return [String] memoフォルダの配下にあるディレクトリの一覧を配列で返す
    def to_dirs
      @dir_set.to_a
    end

    private

    # dir をkey としてentry をHash 化したもの
    def grouped_by_dir
      @entries.group_by(&:dir)
    end

    # メモのファイル名を返す
    def filename(file_path)
      File.basename(file_path, '.md')
    end

    # memoディレクトリをDir.glob で探索して、その中のファイルを読み取るための情報を取得して、Entryに保存する
    #
    # @return [Array<Entry>] 絶対パスなど、メモの中のファイルを読み取るための情報の値データオブジェクト
    def load_entries
      Dir.glob("**/*.md", base: @memo_dir).filter_map do |rel_path|
        next if File.basename(rel_path) == 'README.md'

        Entry.new(
          full_path: File.join(@memo_dir, rel_path),
          dir: File.dirname(rel_path)
        )
      end
    end
  end
end
