# frozen_string_literal: true

module Memo
  class Repository
    include FileUtility
    include Service

    EXCLUDE_FILES = ['README.md'].to_set.freeze

    def initialize(dir)
      @seeds = load(dir)
    end

    # 対象の全てのファイルに文字列検索を行う
    # 検索した文字列がどのファイルにも見当たらなかった場合はnilを返す
    #
    # @param seed [Memo::Model::Seed]
    # @return [Array<Array<Memo::Model::SearchLine>>, nil]
    def search_all(word)
      @seeds.filter_map do |seed|
        search(seed, word)
      end
    end

    # Seeds -> GroupedFileListに変換する関数
    # @return [Array<Memo::Model::GroupedFileList>]
    def grouped_file_list
      @seeds.group_by(&:dir).map do |dir, seed|
        Memo::Model::GroupedFileList.new(
          dir: dir,
          filenames: seed.map(&:filename)
        )
      end
    end

    # seedが存在すれば、そのファイルを全文表示する。
    # TODO: Serviceに移動する
    # nilを受け取った場合は、そのままviewにnilを返す
    # @param [Seed, void]
    # @return [<Array<String>>] 読み取ったメモが行ごとに保存されていて、さらに配列で包まれている。仕様上、複数のファイルを読み取る場合があるため。
    def read(seed)
      return if seed.nil?

      File.readlines(seed.full_path, chomp: true)
    end

    # ファイル名と一致する文字列があれば、そのseedを返す。
    # 見つからなければ、nilを返す
    # TODO: 一度、ファイルが見つかったらそこで探索が終了してしまう
    # @return [Seed, void]
    def find(word)
      @seeds.find { |seed| seed.filename == word }
    end

    # フォルダの中のディレクトリの集合
    #
    # @return [Set<String>]
    def dir_set
      Set.new(@seeds.map(&:dir).uniq).freeze
    end

    private

    # ディレクトリ内をglobで捜索して、ファイルの読み取りや検索に必要な情報を取得する
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
          rel_path: rel_path,
          dir: dir,
          filename: filename(full_path)
        )
      end
    end
  end
end
