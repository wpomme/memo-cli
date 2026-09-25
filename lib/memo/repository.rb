# frozen_string_literal: true

module Memo
  class Repository
    EXCLUDE_FILES = ['README.md'].to_set.freeze

    def initialize(dir)
      @seeds = load(dir)
      @dir_seeds = load_dirs(dir)
      @root_dir = File.basename(dir)
    end

    # 対象の全てのファイルに文字列検索を行う
    # 検索した文字列がどのファイルにも見当たらなかった場合はnilを返す
    #
    # @param seed [Memo::Model::Seed]
    # @return [Array<Array<Memo::Model::SearchLine>>, nil]
    def search_all(word)
      @seeds.filter_map do |seed|
        Memo::Service.search(seed, word)
      end
    end

    # Seeds -> GroupedFileListに変換する関数
    # @return [Array<Memo::Model::GroupedFileList>]
    def grouped_file_list
      @seeds.group_by(&:parent_dir).map do |dir, seed|
        Memo::Model::GroupedFileList.new(
          dir: dir,
          filenames: seed.map(&:basename)
        )
      end
    end

    # grouped_file_listを代替するためのHashを返す関数
    def grouped_file_list_hash
      @seeds.group_by(&:parent_dir).transform_values { |seeds| seeds.map(&:basename) }
    end

    # memo walk CLIに使用するためのseed Hash
    #
    # キーはディレクトリを示す文字列かnilとなる
    # 値はSeedの一次元配列となる
    # キーがnilの場合の値は、最上位を示すディレクトリのSeedが一つだけ入った配列がその値となる
    #
    # @return [Hash<String | nil, Memo::Model::Seed>]
    def grouped_ls
      (@dir_seeds + @seeds).group_by(&:parent_dir)
    end

    # 検索文字列と一致するファイル名の配列を返す
    # 一致するファイル名が見つからなかった場合は空の配列を返す
    #
    # @param word [String]
    # @return [Array<Seed>]
    def find(word)
      @seeds.filter { |seed| seed.basename == word }
    end

    # フォルダの中のディレクトリの集合
    # 対象のディレクトリはルートディレクトリとしてディレクトリの集合の中に加える
    #
    # @return [Set<String>]
    def dir_set
      dirs = @dir_seeds
        .map(&:rel_path)
        .map { |dir| dir.rstrip("/") }
      Set.new(dirs).add(@root_dir)
    end

    private

    # 対象のディレクトリ内をglobで捜索して、その中にあるディレクトリの一覧を取得する
    #
    # @return [Array<String>]
    def load_dirs(root_dir)
      Dir.glob("**/*/", base: root_dir).map do |rel_path|
        full_path = File.join(root_dir, rel_path)

        target_dir = rel_path.rstrip("/")
        parent_dir = File.dirname(target_dir)

        Memo::Model::Seed.new(
          full_path: full_path,
          rel_path: rel_path,
          parent_dir: parent_dir == "." ? File.basename(root_dir) : parent_dir,
          basename: File.basename(rel_path),
          type: :directory
        )
      end
    end

    # 対象のディレクトリ内をglobで捜索して、ファイルの読み取りや検索に必要な情報を取得する
    #
    # @return [Array<Seed>]
    def load(root_dir)
      Dir.glob("**/*.md", base: root_dir).filter_map do |rel_path|
        # README.mdは読み飛ばす
        next if EXCLUDE_FILES.include?(File.basename(rel_path))

        full_path = File.join(root_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        parent_dir = File.dirname(rel_path) == "." ? File.basename(root_dir) : File.dirname(rel_path)

        Memo::Model::Seed.new(
          full_path: full_path,
          rel_path: rel_path,
          parent_dir: parent_dir,
          basename: basename(full_path),
          type: :file
        )
      end
    end

    # ファイルパスから、そのファイルのファイル名を返す
    #
    # @param [String] file_path 対象のファイルのファイルパス
    # @return [String] ファイル名
    def basename(file_path)
      File.basename(file_path, '.md')
    end
  end
end
