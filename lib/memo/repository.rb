# frozen_string_literal: true

module Memo
  class Repository
    include Enumerable
    include MemoFileUtility

    EXCLUDE_FILES = ['README.md'].to_set.freeze

    #  memoディレクトリの中のファイルの情報を保存するための値オブジェクト
    #  もしかしたらEntryはMemoの外に出した方がいいかも
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] filename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    Entry = Data.define(:full_path, :filename, :dir)

    def initialize(memo_dir)
      @entries = load(memo_dir)
    end

    def each(&)
      @entries.each(&)
    end

    # entryが存在すれば、そのファイルを全文表示する。
    # nilを受け取った場合は、そのままpresenterにnilを返す
    # @param [Entry, void]
    # @return [<Array<String>>] 読み取ったメモが行ごとに保存されていて、さらに配列で包まれている。仕様上、複数のファイルを読み取る場合があるため。
    def read(entry)
      return if entry.nil?

      File.readlines(entry.full_path, chomp: true)
    end

    # ファイル名と一致する文字列があれば、そのentryを返す。
    # 見つからなければ、nilを返す
    # TODO: 一度、ファイルが見つかったらそこで探索が終了してしまう
    # @return [Entry, void]
    def find(word)
      @entries.find { |entry| entry.filename == word }
    end

    # ディレクトリの集合を配列に変換する
    #
    # @return [Array<String>] フォルダの配下にあるディレクトリの一覧を配列で返す
    def to_dirs
      dir_set.to_a.freeze
    end

    # フォルダの中のディレクトリの集合
    #
    # @return [Set<String>]
    def dir_set
      Set.new(@entries.map(&:dir).uniq).freeze
    end

    private

    # ディレクトリ内をglobで捜索して、ファイルの読み取りや検索に必要な情報を取得する
    #
    # @return [Array<Entry>]
    def load(memo_dir)
      Dir.glob("**/*.md", base: memo_dir).filter_map do |rel_path|
        # README.mdは読み飛ばす
        next if EXCLUDE_FILES.include?(File.basename(rel_path))

        full_path = File.join(memo_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        dir = File.dirname(rel_path) == "." ? File.basename(memo_dir) : File.dirname(rel_path)

        Entry.new(
          full_path: full_path,
          filename: filename(full_path),
          dir: dir
        )
      end
    end
  end
end
