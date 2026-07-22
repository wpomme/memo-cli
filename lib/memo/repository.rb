# frozen_string_literal: true

module Memo
  class Repository
    # include Enumerable
    include FileUtility

    EXCLUDE_FILES = ['README.md'].to_set.freeze

    # seedが存在すれば、そのファイルを全文表示する。
    # nilを受け取った場合は、そのままviewにnilを返す
    # @param [Seed, void]
    # @return [<Array<String>>] 読み取ったメモが行ごとに保存されていて、さらに配列で包まれている。仕様上、複数のファイルを読み取る場合があるため。
    def self.read(seed)
      return if seed.nil?

      File.readlines(seed.full_path, chomp: true)
    end

    def initialize(memo_dir)
      @seeds = load(memo_dir)
    end

    # モックデータ作成のため@seedsを読み取り可能にしておく
    attr_reader :seeds

    # ファイル名と一致する文字列があれば、そのseedを返す。
    # 見つからなければ、nilを返す
    # TODO: 一度、ファイルが見つかったらそこで探索が終了してしまう
    # FIXME: Enumerableのfindと名前が衝突しているはず
    # @return [Seed, void]
    def find(word)
      @seeds.find { |seed| seed.filename == word }
    end

    # Structを返す新しいデータ
    # grouped = repo.grouped_file_list
    # grouped.class => Array
    # その中身はMemo::Model::GroupedFileListとなる
    # 値はSet<Hash>
    # @return [Array<Memo::Model::GroupedFileList>]
    def grouped_file_list
      seeds_grouped_by_dir(@seeds).map do |dir, seed|
        Memo::Model::GroupedFileList.new(
          dir: dir,
          # NOTE: テストコードのためsortする。別にソートする必要はない
          filenames: seed.map(&:filename).sort
        )
      end
    end

    # ディレクトリとその中に入っているメモファイルの配列を返す
    # dirをkeyにして、ファイルの配列を集合にしたもののハッシュを返却してもいいかも
    # 返す値は、キーがディレクトリの文字列で、値がそのディレクトリに所属するファイル名の配列
    # NOTE: 値の配列はfreezeした方がいいのかな？一応freezeしておくか
    # TODO: Modelに移動
    # @return [Hash<String, Set<String>>]
    def files_grouped_by_dir
      grouped_files = {}
      to_dirs.each do |key|
        grouped_files[key] = seeds_grouped_by_dir(@seeds)[key].to_set(&:filename).freeze
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
      Set.new(@seeds.map(&:dir).uniq).freeze
    end

    # ディレクトリ内をglobで捜索して、ファイルの読み取りや検索に必要な情報を取得する
    #
    # 1. EXCLUDE_FILESに記載されているファイルは読み飛ば（例: README.mdなど）
    # 2. フォルダの最上位に存在するファイルは、globだけだと所属するディレクトリが"."になってしまう
    #    そのため、その親のディレクトリがdirに入るように実装している。
    #
    # @return [Array<Seed>]
    def load(memo_dir)
      Dir.glob("**/*.md", base: memo_dir).filter_map do |rel_path|
        # README.mdは読み飛ばす
        next if EXCLUDE_FILES.include?(File.basename(rel_path))

        full_path = File.join(memo_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        dir = File.dirname(rel_path) == "." ? File.basename(memo_dir) : File.dirname(rel_path)

        Memo::Model::Seed.new(
          full_path: full_path,
          filename: filename(full_path),
          dir: dir
        )
      end
    end
  end
end
