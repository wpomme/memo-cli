# frozen_string_literal: true

module Memo
  class Repository
    EXCLUDE_FILES = ['README.md'].to_set.freeze

    def initialize(dirs)
      @file_seeds = dirs.map { |dir| load_files(dir) }.flatten
      @dir_seeds = dirs.map { |dir| load_dirs(dir) }.flatten
      @root_dirs = dirs.map { |dir| File.basename(dir) }
    end

    # 対象の全てのファイルに文字列検索を行う
    # 検索した文字列がどのファイルにも見当たらなかった場合はnilを返す
    #
    # @param seed [Memo::Model::Seed]
    # @return [Array<Array<Memo::Model::SearchLine>>, nil]
    def search_all(word)
      @file_seeds.filter_map do |seed|
        Memo::Service.search(seed, word)
      end
    end

    # 対象のファイルで使われているtagの一覧を返す
    #
    # @return [Array<String>]
    def tag_list
      @file_seeds.map(&:tags).flatten.uniq
    end

    # タグの付けられていないファイル名の一覧を返す
    #
    # @return [Array<Seed>]
    def empty_tags_file_list
      @file_seeds.filter { |seed| seed['tags'].empty? }
    end

    # それぞれのタグと、そのタグが付いているSeedの配列のハッシュを返す
    #
    # @return [Hash<String, Array<String>>]
    def tag_seeds_hash
      tag_list.to_h do |tag|
        [
          tag,
          @file_seeds.filter do |seed|
            seed['tags'].include?(tag)
          end
        ]
      end
    end

    # 対象のディレクトリ配下にあるディレクトリとファイルのSeedを、ディレクトリごとにグループ化しハッシュとして返す
    #
    # キーはディレクトリを示す文字列となる
    # 値はSeedの一次元配列となる
    #
    # @return [Hash<String, Array<Memo::Model::Seed>>]
    def grouped_ls
      (@dir_seeds + @file_seeds).group_by(&:parent_dir)
    end

    # 検索文字列と一致するファイル名の配列を返す
    # 一致するファイル名が見つからなかった場合は空の配列を返す
    #
    # @param word [String]
    # @return [Array<Seed>]
    def find(word)
      @file_seeds.filter { |seed| seed.basename == word }
    end

    # フォルダの中のディレクトリの集合
    # 対象のディレクトリはルートディレクトリとしてディレクトリの集合の中に加える
    #
    # @return [Set<String>]
    def dir_set
      dirs = @dir_seeds
        .map(&:rel_path)
        .map { |dir| dir.rstrip('/') }
      Set.new(dirs).merge(@root_dirs)
    end

    private

    # 対象のディレクトリ内をglobで捜索して、その中にあるディレクトリの一覧を取得する
    #
    # @return [Array<String>]
    def load_dirs(root_dir)
      Dir.glob('**/*/', base: root_dir).map do |rel_path|
        full_path = File.join(root_dir, rel_path)

        target_dir = rel_path.rstrip('/')
        parent_dir = File.dirname(target_dir)

        Memo::Model::Seed.new(
          full_path: full_path,
          rel_path: rel_path,
          target_dir: root_dir,
          parent_dir: parent_dir == '.' ? File.basename(root_dir) : parent_dir,
          basename: File.basename(rel_path),
          type: :directory,
          tags: []
        )
      end
    end

    # 対象のディレクトリ内をglobで捜索して、ファイルの読み取りや検索に必要な情報を取得する
    #
    # @return [Array<Seed>]
    def load_files(root_dir)
      Dir.glob('**/*.md', base: root_dir).filter_map do |rel_path|
        # README.mdは読み飛ばす
        next if EXCLUDE_FILES.include?(File.basename(rel_path))

        full_path = File.join(root_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        parent_dir = File.dirname(rel_path) == '.' ? File.basename(root_dir) : File.dirname(rel_path)

        # 各ファイルからフロントマターを読み取って、tagsの値をSeedにセットする。
        # tagsの値がnilなら、tagsには空の配列を入れる
        content = File.readlines(full_path, chomp: true)

        front_matter = Memo::Service.parse_yaml_front_matter(content.join("\n"))

        Memo::Model::Seed.new(
          full_path: full_path,
          rel_path: rel_path,
          target_dir: root_dir,
          parent_dir: parent_dir,
          basename: basename(full_path),
          type: :file,
          tags: front_matter['tags'].nil? ? [] : front_matter['tags']
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
