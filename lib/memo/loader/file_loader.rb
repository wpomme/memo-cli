# frozen_string_literal: true

module Memo
  class FileLoader
    include Memo::Structure

    attr_reader :file_seeds

    def initialize(target_dirs: Memo::Config.target_dirs)
      @file_seeds = load_file_seeds(target_dirs).flatten
    end

    # 全てのタグの一覧をソートし、重複を排除してから、その一覧を返す
    # 名前順に並んでいる
    #
    # @return [Array<String>]
    def sorted_tags
      tag_list.sort
    end

    # 重複を排除した上で、全てのタグの総数を返す
    #
    # @return [Integer]
    def tag_size
      tag_list.size
    end

    # 全てのファイルに出現するタグの数について、重複しているものをまとめないで返す
    #
    # @return [Integer]
    def total_tag_size
      tag_size_by_filename.values.inject(:+)
    end

    # 対象ファイルの絶対パスがキーで、そのファイルに付けられているタグの一覧をハッシュで返す
    # Database::Setup#seedsに必要
    #
    # @return [Hash<String, Array<String>>]
    def absolute_filename_to_tags
      @absolute_filename_to_tags ||= file_seeds.to_h do |file_seed|
        [file_seed[:absolute_path], file_seed[:tags]]
      end
    end

    # タグの付いている数が多いものから順に並べる
    #
    # @return [Array<Array<String, Integer>>]
    def tags_sorted_by_file_size
      @tags_sorted_by_file_size ||= tag_files_size.to_a.sort do |a, b|
        b[1] <=> a[1]
      end
    end

    # それぞれのタグと、そのタグが付いているファイルの数のハッシュを返す
    #
    # @return [Hash<String, Array<String>>]
    def tag_files_size
      @tag_files_size ||= tag_files_hash
        .transform_values(&:size)
    end

    # それぞれのタグと、そのタグが付いているSeedの配列のハッシュを返す
    #
    # @return [Hash<String, Array<String>>]
    def tag_files_hash
      @tag_files_hash ||= tag_list.to_h do |tag|
        [
          tag,
          file_seeds.filter_map do |file_seed|
            file_seed[:filename] if file_seed[:tags].include?(tag)
          end
        ]
      end
    end

    # タグの付いていないファイルのseedを配列で返す
    def file_seeds_without_tags
      file_seeds.filter do |file_seed|
        file_seed[:tags].empty?
      end
    end

    # 対象となるファイルの総数を返す
    #
    # @return [Integer]
    def file_list_size
      file_seeds.size
    end

    private

    # ファイルごとに付いているタグの数をハッシュで返す
    def tag_size_by_filename
      @tag_size_by_filename ||= absolute_filename_to_tags.transform_values(&:size)
    end

    # TODO: View::Listと紐付けする
    # 重複したファイル名を持つfile_seedの配列を返す
    #
    # @return [Hash<String, Integer>]
    def duplicated_filenames_seeds
      file_seeds.filter do |file_seed|
        filenames.count(file_seed[:filename]) > 1
      end
    end

    # TODO: View::Listと紐付けする
    # 重複したファイル名があれば、次のようなハッシュが返ってくる
    # {"array" => 2, "builtin" => 2, "command" => 2, "diff" => 2, "mise" => 2}
    #
    # @return [Hash<String, Integer>]
    def duplicated_filenames_hash
      filenames.filter do |filename|
        filenames.count(filename) > 1
      end.tally
    end

    # 全てのタグの一覧。ソートしていない
    #
    # [Array<String>]
    def tag_list
      @tag_list ||= file_seeds.map do |file_seed|
        file_seed[:tags]
      end.flatten.uniq
    end

    # 対象のディレクトリ内のファイルを読み込んで、DBに保存するためのfile_seeds_hashを作成する
    #
    # @return [Hash<String, Array>] 設定ディレクトリがキーで、そのディレクトリ内のファイルに関する情報の配列が値となるハッシュを返す
    def load_file_seeds(target_dirs)
      @load_file_seeds ||= target_dirs.filter_map do |target_dir|
        Dir.glob('**/*.md', base: target_dir).filter_map do |rel_path|
          next if ['README.md'].include?(File.basename(rel_path))

          absolute_path = File.join(target_dir, rel_path)
          file_content = File.readlines(absolute_path).join

          tags = get_tags_from_file_content(file_content)

          FileSeed.create(target_dir, absolute_path, rel_path, file_content, tags)
        end
      end
    end

    # フロントマターからtagsの値を返す
    def get_tags_from_file_content(file_content)
      front_matter = Memo::Service.parse_yaml_front_matter(file_content)
      front_matter['tags'].nil? ? [] : front_matter['tags']
    end
  end
end
