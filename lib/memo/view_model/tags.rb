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

      def default
        tags_to_view(@file_loader.tag_files_hash)
      end

      def empty
        grouped_seeds_to_view(@file_loader.empty_tag_hash)
      end

      def count
        tags_count_to_view(@file_loader.tags_array_sorted_by_file_size)
      end

      def name
        @file_loader.tags_sorted_by_tag_name
      end

      private

      def tags_count_to_view(hash)
        hash.map do |k, v|
          ["#{k}: #{v}"]
        end
      end

      # memo tagsをユーザー向けに色付け・値の加工をして結果を返す
      #
      # @param seeds_hash [Hash<String, Array<Seed>>] 文字列がキーで、値がSeedの配列となるハッシュ
      # @return [String]
      def tags_to_view(seeds_hash)
        seeds_hash.map do |(key, files)|
          tag_and_size = tag_color("#{key}: #{files.size}")
          "#{tag_and_size}\n#{files.join(SPACE)}"
        end.join("\n\n")
      end
    end
  end
end
