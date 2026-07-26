# frozen_string_literal: true

module Memo
  module Model
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #  Repositoryの内部で使用するため、Memo::Model::Seedとして使用する
    #  TODO: 読み取り専用にする
    #
    # @!attribute [rw] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [rw] rel_path
    #   @return [String] 対象のディレクトリからそのファイルへのパス
    # @!attribute [rw] dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # @!attribute [rw] filename
    #   @return [String] 対象のファイルのファイル名
    Seed = Data.define(:full_path, :rel_path, :dir, :filename)

    # 対象のディレクトリの中にあるファイル名の配列を保存する
    # :dirは文字列、:filenamesは文字列の配列が入る
    GroupedFileList = Struct.new("GroupedFileList", :dir, :filenames)

    # 対象のディレクトリを文字列で検索してヒットしたときに返す値
    # TODO: SearchLineにリネームする
    GrepLine = Struct.new("GrepLine", :path, :line_number, :line)

    # ファイルごとに文字列で検索をかけてヒットしたらその行のほか、ファイル名などの情報を返す
    # @params seed [Seed]
    # @return [Array<GrepLine>]
    def search(seed, word)
      # TODO: Pathname.relative_path_fromを使って相対パスにする
      # readlinesの前にあらかじめ相対パスを作成しておく
      File.readlines(seed.full_path, chomp: true)
        .each_with_index
        .filter_map do |line, index|
          GrepLine.new(path: seed.rel_path, line_number: index, line: line) if line.include?(word)
        end
    end

    # TODO: Modelに移動
    # Seeds -> GroupedFileListに変換する関数
    # grouped = repo.grouped_file_list
    # grouped.class => Array
    # その中身はMemo::Model::GroupedFileListとなる
    # 値はSet<Hash>
    # @return [Array<Memo::Model::GroupedFileList>]
    def grouped_file_list(seeds)
      seeds.group_by(&:dir).map do |dir, seed|
        GroupedFileList.new(
          dir: dir,
          filenames: seed.map(&:filename)
        )
      end
    end
  end
end
