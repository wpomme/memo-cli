# frozen_string_literal: true

module Memo
  class Repository
    EXCLUDE_FILES = ['README.md'].to_set.freeze

    def initialize(dir)
      @seeds = load(dir)
      @root_dir = dir
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
      @seeds.group_by(&:dir).map do |dir, seed|
        Memo::Model::GroupedFileList.new(
          dir: dir,
          filenames: seed.map(&:filename)
        )
      end
    end

    # 検索文字列と一致するファイル名の配列を返す
    # 一致するファイル名が見つからなかった場合は空の配列を返す
    #
    # @param word [String]
    # @return [Array<Seed>]
    def find(word)
      @seeds.filter { |seed| seed.filename == word }
    end

    # parent_dir: @root_dirと同じなら、ディレクトリのトップである。parent_dirはnilに設定する
    #
    # @return [Array<DirSeed>]
    def dir_seeds
      dir_set.map { |dir| Model::DirSeed.new(dir, @root_dir) }
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
    def load(root_dir)
      Dir.glob("**/*.md", base: root_dir).filter_map do |rel_path|
        # README.mdは読み飛ばす
        next if EXCLUDE_FILES.include?(File.basename(rel_path))

        full_path = File.join(root_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        dir = File.dirname(rel_path) == "." ? File.basename(root_dir) : File.dirname(rel_path)

        Memo::Model::Seed.new(
          full_path: full_path,
          rel_path: rel_path,
          dir: dir,
          filename: filename(full_path)
        )
      end
    end

    # ファイルパスから、そのファイルのファイル名を返す
    #
    # @param [String] file_path 対象のファイルのファイルパス
    # @return [String] ファイル名
    def filename(file_path)
      File.basename(file_path, '.md')
    end
  end
end
