# frozen_string_literal: true

module Memo
  module Loader
    # 対象のディレクトリを走査してデータベースに必要なデータを取得するためのクラス
    # 何度も走査しないように、キャッシュを取得する
    class FileLoader
      def initialize
        @file_seeds_hash = load_file_seeds_hash
      end

      # 全てのタグの一覧をソートし、重複を排除してから、その一覧を返す
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
      #
      # @return [Hash<String, Array<String>>]
      def absolute_filename_to_tags
        @file_seeds_hash.values.flatten.to_h do |file_hash|
          [file_hash[:absolute_path], file_hash[:tags]]
        end
      end

      # それぞれのタグと、そのタグが付いているSeedの配列のハッシュを返す
      #
      # @return [Hash<String, Array<String>>]
      def tag_files_hash
        tag_list.to_h do |tag|
          [
            tag,
            @file_seeds_hash.keys.map do |key|
              @file_seeds_hash[key].filter_map do |file_hash|
                file_hash[:filename] if file_hash[:tags].include?(tag)
              end
            end
          ]
        end
      end

      # 対象となるファイルの総数を返す
      #
      # @return [Integer]
      def file_list_size
        file_list_size_by_config_directory.values.inject(:+)
      end

      def file_seeds_to_search
        @file_seeds_hash.transform_values do |values|
          values.map do |value|
            {
              filename: value[:filename],
              parent_rel_path: value[:parent_rel_path],
              file_content: value[:file_content]
            }
          end
        end
      end

      def file_seeds_to_read
        @file_seeds_hash.transform_values do |values|
          values.map do |value|
            {
              filename: value[:filename],
              parent_directory: value[:parent_directory],
              file_content: value[:file_content]
            }
          end
        end
      end

      def file_seeds_to_database
        @file_seeds_hash.transform_values do |values|
          values.map do |value|
            {
              filename: value[:filename],
              parent_directory: value[:parent_directory],
              file_content: value[:file_content]
            }
          end
        end
      end

      private

      # 設定ディレクトリごとのファイルの総数をハッシュで返す
      #
      # @return [Hash<String, Integer>]
      def file_list_size_by_config_directory
        @file_seeds_hash.transform_values(&:size)
      end

      # ファイルごとに付いているタグの数をハッシュで返す
      def tag_size_by_filename
        @tag_size_by_filename ||= absolute_filename_to_tags.transform_values(&:size)
      end

      # 全てのタグの一覧。ソートしていない
      #
      # [Array<String>]
      def tag_list
        @tag_list ||= absolute_filename_to_tags.values.flatten.uniq
      end

      # 対象のディレクトリ内のファイルを読み込んで、DBに保存するためのfile_seeds_hashを作成する
      #
      # @return [Hash<String, Array>] 設定ディレクトリがキーで、そのディレクトリ内のファイルに関する情報の配列が値となるハッシュを返す
      def load_file_seeds_hash(target_dirs = Memo::Config.target_dirs)
        @load_file_seeds_hash ||= target_dirs.to_h do |target_dir|
          file_seeds = Dir.glob('**/*.md', base: target_dir).filter_map do |rel_path|
            next if ['README.md'].include?(File.basename(rel_path))

            absolute_path = File.join(target_dir, rel_path)
            rel_dirname = File.dirname(rel_path)
            file_content = File.readlines(absolute_path).join

            # tagsのための処理
            # add_file_path_tags_hash(absolute_path, file_content)
            front_matter = Memo::Service.parse_yaml_front_matter(file_content)
            tags = front_matter['tags'].nil? ? [] : front_matter['tags']

            {
              absolute_path: absolute_path,
              parent_directory: File.dirname(absolute_path) << '/',
              parent_rel_path: rel_dirname == '.' ? '' : rel_dirname << '/',
              filename: File.basename(absolute_path, '.md'),
              file_content: file_content,
              tags: tags
            }
          end

          [target_dir, file_seeds]
        end
      end
    end
  end
end
