# frozen_string_literal: true

module Memo
  module Database
    # 対象のディレクトリを走査してデータベースに必要なデータを取得するためのクラス
    # 何度も走査しないように、キャッシュを取得する
    class FileLoader
      def initialize
        # @file_hash_seeds = []
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

      # 全てのファイルの情報をハッシュにして一次元配列に保存したメソッド
      #
      # @return [Array<Hash<symbol, String>>]
      # def file_hash_seeds
      #   load_files unless load_files_called?
      #
      #   @file_hash_seeds
      # end

      # ファイルパスと、そのファイルに付けられているタグ名の配列のハッシュを返す
      #
      # @return [Hash<String, Array<String>>]
      def file_path_tags_hash
        load_file_seeds_hash unless load_files_called?

        @file_path_tags_hash
      end

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

      # def load_files(target_dirs = Memo::Config.target_dirs)
      #   target_dirs.flat_map do |root_dir|
      #     Dir.glob('**/*.md', base: root_dir).filter_map do |rel_path|
      #       next if ['README.md'].include?(File.basename(rel_path))
      #
      #       absolute_path = File.join(root_dir, rel_path)
      #       file_content = File.readlines(absolute_path).join("\n")
      #
      #       front_matter = Memo::Service.parse_yaml_front_matter(file_content)
      #
      #       tags = front_matter['tags'].nil? ? [] : front_matter['tags']
      #
      #       @file_hash_seeds << {
      #         absolute_path: absolute_path,
      #         # DBには挿入しないが、CLIの方で使う
      #         basename: File.basename(absolute_path, '.md'),
      #         parent_directory: File.dirname(absolute_path) << '/',
      #         file_content: file_content
      #       }
      #
      #       @file_path_tags_hash[absolute_path] = tags
      #     end
      #   end
      #
      #   @method_called_count += 1
      # end

      # TODO: このメソッドから、load_filesを作成する
      # このメソッドはDir.globを行うことで、@file_path_tags_hashを生成するという副作用がある
      # また、file_hash_seedsを直接呼び出すようになる
      def load_file_seeds_hash(target_dirs = Memo::Config.target_dirs)
        @load_file_seeds_hash ||= target_dirs.to_h do |target_dir|
          file_seeds = Dir.glob('**/*.md', base: target_dir).filter_map do |rel_path|
            next if ['README.md'].include?(File.basename(rel_path))

            absolute_path = File.join(target_dir, rel_path)
            file_content = File.readlines(absolute_path).join("\n")

            front_matter = Memo::Service.parse_yaml_front_matter(file_content)

            tags = front_matter['tags'].nil? ? [] : front_matter['tags']

            @file_path_tags_hash[absolute_path] = tags

            {
              absolute_path: absolute_path,
              parent_directory: File.dirname(rel_path) << '/',
              filename: File.basename(absolute_path, '.md'),
              file_content: file_content
            }
          end

          [target_dir, file_seeds]
        end
      end
    end
  end
end
