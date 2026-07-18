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

    # entryが存在すれば、そのファイルを全文表示する。
    # nilを受け取った場合は、そのままpresenterにnilを返す
    # @param [Entry, void]
    # @return [<Array<String>>] 読み取ったメモが行ごとに保存されていて、さらに配列で包まれている。仕様上、複数のファイルを読み取る場合があるため。
    def self.read(entry)
      return if entry.nil?

      File.readlines(entry.full_path, chomp: true)
    end

    def initialize(memo_dir)
      @entries = load(memo_dir)
    end

    # @deprecate
    def each(&)
      @entries.each(&)
    end

    # ファイル名と一致する文字列があれば、そのentryを返す。
    # 見つからなければ、nilを返す
    # TODO: 一度、ファイルが見つかったらそこで探索が終了してしまう
    # @return [Entry, void]
    def find(word)
      @entries.find { |entry| entry.filename == word }
    end

    # Structを返す新しいデータ
    # grouped = repo.grouped_file_list
    # grouped.class => Array
    # その中身はMemo::GroupedFileListとなる
    #
    # @return [Array<Memo::GroupedFileList>]
    #
    def grouped_file_list
      entries_grouped_by_dir(@entries).map do |dir, entry|
        Memo::GroupedFileList.new(
          dir: dir,
          file_hash: entry.to_set { |entry| { entry.filename => entry.full_path } }
        )
      end
    end

    # ディレクトリとその中に入っているメモファイルの配列を返す
    # dirをkeyにして、ファイルの配列を集合にしたもののハッシュを返却してもいいかも
    # 返す値は、キーがディレクトリの文字列で、値がそのディレクトリに所属するファイル名の配列
    # NOTE: 値の配列はfreezeした方がいいのかな？一応freezeしておくか
    # @return [Hash<String, Set<String>>]
    def files_grouped_by_dir
      grouped_files = {}
      to_dirs.each do |key|
        grouped_files[key] = entries_grouped_by_dir(@entries)[key].to_set(&:filename).freeze
      end
      grouped_files
    end

    # ディレクトリの集合を配列に変換する
    #
    # @return [Array<String>] フォルダの配下にあるディレクトリの一覧を配列で返す
    def to_dirs
      dir_set.to_a.freeze
    end

    private

    # フォルダの中のディレクトリの集合
    #
    # @return [Set<String>]
    def dir_set
      Set.new(@entries.map(&:dir).uniq).freeze
    end

    # ディレクトリ内をglobで捜索して、ファイルの読み取りや検索に必要な情報を取得する
    #
    # 1. EXCLUDE_FILESに記載されているファイルは読み飛ば（例: README.mdなど）
    # 2. フォルダの最上位に存在するファイルは、globだけだと所属するディレクトリが"."になってしまう
    #    そのため、その親のディレクトリがdirに入るように実装している。
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
