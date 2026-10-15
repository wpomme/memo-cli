# frozen_string_literal: true

module Memo
  module Database
    # 対象のディレクトリを走査してデータベースに必要なデータを取得するためのクラス
    # 何度も走査しないように、キャッシュを取得する
    class FileLoader
      def initialize
        @file_path_tags_hash = {}
      end

      # 全てのサグの一覧をソートし、重複を排除してから、その一覧を返す
      #
      # @return [Array<String>]
      def all_tags
        all_tags_array.sort.uniq
      end

      # 重複を排除した上で、全てのタグの総数を返す
      #
      # @return [Integer]
      def all_tag_count_of_list
        all_tags_array.uniq.size
      end

      # 全てのファイルに出現するタグの数について、重複しているものをまとめないで返す
      #
      # @return [Integer]
      def all_tag_count_of_appearance
        all_tags_array.size
      end

      # ファイルパスと、そのファイルに付けられているタグ名の配列のハッシュを返す
      #
      # @return [Hash<String, Array<String>>]
      def file_path_tags_hash
        load_file_seeds_hash unless load_files_called?

        @file_path_tags_hash
      end

      # 全てのファイルの情報をハッシュにして一次元配列に保存したメソッド
      #
      def file_seeds_hash
        load_file_seeds_hash unless load_files_called?

        @load_file_seeds_hash
      end

      private

      def all_tags_array
        @all_tags_array ||= file_path_tags_hash.values.flatten
      end

      def load_files_called?
        @load_files_called ||= !@load_file_seeds_hash.nil?
      end

      # 対象のディレクトリ内のファイルを読み込んで、DBに保存するためのfile_seeds_hashを作成する
      # このメソッドには、@file_path_tags_hashを生成するという副作用がある
      #
      # @return [Hash<String, Array>] 設定ディレクトリがキーで、そのディレクトリ内のファイルに関する情報の配列が値となるハッシュを返す
      def load_file_seeds_hash(target_dirs = Memo::Config.target_dirs)
        @load_file_seeds_hash ||= target_dirs.to_h do |target_dir|
          file_seeds = Dir.glob('**/*.md', base: target_dir).filter_map do |rel_path|
            next if ['README.md'].include?(File.basename(rel_path))

            absolute_path = File.join(target_dir, rel_path)
            rel_dirname = File.dirname(rel_path)
            file_content = File.readlines(absolute_path).join("\n")

            # tagsのための処理
            add_file_path_tags_hash(absolute_path, file_content)

            {
              absolute_path: absolute_path,
              parent_directory: rel_dirname == '.' ? '' : rel_dirname << '/',
              filename: File.basename(absolute_path, '.md'),
              file_content: file_content
            }
          end

          [target_dir, file_seeds]
        end
      end

      def add_file_path_tags_hash(absolute_path, file_content)
        front_matter = Memo::Service.parse_yaml_front_matter(file_content)
        tags = front_matter['tags'].nil? ? [] : front_matter['tags']
        @file_path_tags_hash[absolute_path] = tags
      end
    end
  end
end
