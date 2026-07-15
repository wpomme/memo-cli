# frozen_string_literal: true

require 'rainbow'

module Memo
  class Docs
    Entry = Data.define(:full_path, :dir)

    def self.dirs(memo_dir)
      new(memo_dir).to_dirs.each { |d| puts d }
    end

    def initialize(memo_dir)
      # @memo_dir = File.join(File.expand_path("..", memo_dir), 'docs')
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

    def to_dirs
      @dir_set.to_a
    end

    # メモのディレクトリを赤字で表示し、そのディレクトリごとのファイル名を出力する
    def print_files
      grouped_by_dir.each_key do |key|
        puts Rainbow(key).green
        grouped_by_dir[key].each do |entry|
          puts filename(entry.full_path)
        end
      end
    end

    def print_files_by_dir(dir)
      files = files_by_dir(dir)
      unless files
        puts "#{dir} というディレクトリはありません。"
        exit!(1)
      end

      files.each do |entry|
        puts filename(entry.full_path)
      end
    end

    private

    # nil か dir ごとのfiles を返す
    def files_by_dir(dir)
      return unless grouped_by_dir.key?(dir)

      grouped_by_dir[dir]
    end

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
