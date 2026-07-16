# frozen_string_literal: true

require 'rainbow'

module Memo
  class Docs
    Entry = Data.define(:full_path, :dir)

    class << self
      def dirs(memo_dir)
        puts new(memo_dir).to_dirs
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

    def initialize(memo_dir)
      @memo_dir = memo_dir
      @entries = load_entries
      @dir_set = Set.new(@entries.map(&:dir).uniq)
    end

    # メモの中にあるファイルをword で検索して、そのword のメモがあれば、メモの内容を出力する
    # なければ、ないと出力する
    # また、word がディレクトリなら、そのディレクトリの下にあるメモの一覧を返す
    def read_and_print_content(word)
      filtered_full_path = @entries.filter { |entry| filename(entry.full_path) == word }

      if filtered_full_path.empty?
        if @dir_set.include?(word)
          puts "#{word} はメモのディレクトリです。"
          puts "#{word} の中にあるメモの一覧: "
          print_files_by_dir(word)
        else
          puts "#{word} というメモはありません。"
        end
      end

      filtered_full_path
        .map { |entry| File.readlines(entry.full_path, chomp: true) }
        .map { |line| puts(line) }
    end

    def print_files_by_dir(dir)
      unless grouped_by_dir.key?(dir)
        puts "#{dir} というディレクトリはありません。"
        exit!(1)
      end

      files = grouped_by_dir[dir]

      files.each do |entry|
        puts filename(entry.full_path)
      end
    end

    def to_files_by_dir(dir)
      return unless grouped_by_dir.key?(dir)

      grouped_by_dir[dir].map { |entry| filename(entry.full_path) }
    end

    # ディレクトリとその中に入っているメモファイルの配列を返す
    def to_files
      grouped_by_dir.map do |key, entries|
        [Rainbow(key).green, entries.map { |entry| filename(entry.full_path) }]
      end
    end

    # ディレクトリの集合を配列に変換する
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

    # docs 以下をDir.glob で探索して、docs 以下のファイルのフルパスと所属するdir 名を返す
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
