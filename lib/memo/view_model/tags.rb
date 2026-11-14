# frozen_string_literal: true

module Memo
  module ViewModel
    class Tags
      include Memo::ViewModel

      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
        @to_relative_dir = @directory_loader.to_relative_dir
      end

      def execute(option)
        return seeds_hash_to_view(@file_loader.tag_files_hash) if option == true

        return count_hash_to_view(@file_loader.tags_sorted_by_file_size) if option == :count

        @file_loader.tags_sorted_by_tag_name if option == :name
      end

      def empty
        @file_loader.seeds_grouped_by_directory
      end

      private

      def parent_directory_to_filenames_without_tags
        result = {}

        @file_loader.file_seeds.each do |file_seed|
          (result[file_seed[:parent_directory]] ||= []) << file_seed[:filename] if file_seed[:tags].empty?
        end

        result
      end

      def count_hash_to_view(hash)
        hash.map do |k, v|
          ["#{k}: #{v}"]
        end
      end

      # グループ化されたSeedのハッシュについて、グループごとのファイル名を文字列にして返す
      #
      # @param seeds_hash [Hash<String, Array<Seed>>] 文字列がキーで、値がSeedの配列となるハッシュ
      # @param color_symbol [Symbol] キーの色付けを指定する
      # @return [Array<String>]
      def seeds_hash_to_view(seeds_hash)
        result = seeds_hash.inject([]) do |result, (key, files)|
          result << tag_color("#{key}: #{files.size}") << files.join(SPACE) << "\n"
        end

        remove_last_element(result)
      end
    end
  end
end
