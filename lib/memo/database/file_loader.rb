# frozen_string_literal: true

module Memo
  module Database
    # 対象のディレクトリを走査してデータベースに必要なデータを取得するためのクラス
    # 何度も走査しないように、キャッシュを取得する
    class FileLoader
      def initialize
        @file_hash_seeds = []
        @file_path_tags_hash = {}
        @method_called_count = 0
      end

      def all_tags
        file_path_tags_hash.values.flatten.sort.uniq
      end

      # 全てのファイルに出現するタグの数について、重複しているものをまとめないで返す
      #
      # @return [Integer]
      def all_tag_count_of_appearance
        file_path_tags_hash.values.flatten.size
      end

      def file_hash_seeds
        load_files unless load_files_called?

        @file_hash_seeds
      end

      # ファイルパスと、そのファイルに付けられているタグ名の配列のハッシュを返す
      #
      # @return [Hash<String, Array<String>>]
      def file_path_tags_hash
        load_files unless load_files_called?

        @file_path_tags_hash
      end

      private

      def load_files_called?
        !@method_called_count.zero?
      end

      def load_files(target_dirs = Memo::Config.target_dirs)
        target_dirs.flat_map do |root_dir|
          Dir.glob('**/*.md', base: root_dir).filter_map do |rel_path|
            next if ['README.md'].include?(File.basename(rel_path))

            absolute_path = File.join(root_dir, rel_path)
            file_content = File.readlines(absolute_path).join("\n")

            front_matter = Memo::Service.parse_yaml_front_matter(file_content)

            tags = front_matter['tags'].nil? ? [] : front_matter['tags']

            @file_hash_seeds << {
              absolute_path: absolute_path,
              parent_directory: File.dirname(absolute_path) << '/',
              file_content: file_content
            }

            @file_path_tags_hash[absolute_path] = tags
          end
        end

        @method_called_count += 1
      end
    end
  end
end
