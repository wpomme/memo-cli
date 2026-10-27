# frozen_string_literal: true

module Memo
  module View
    class Tags
      def run(option)
        execute(option)
      end

      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      private

      def execute(option)
        return seeds_hash_to_view(@file_loader.tag_files_hash, TAG_COLOR) if option == true

        return count_hash_to_view(@file_loader.sorted_tag_files_size) if option == :count

        return empty_seeds_to_view(@file_loader.file_seeds_without_tags) if option == :empty

        @file_loader.sorted_tags if option == :name
      end

      def empty_seeds_to_view(file_seeds)
        grouped = file_seeds.group_by { |file_seed| file_seed[:parent_rel_path] }
          .transform_values do |values|
            values.map do |seed|
              seed[:filename]
            end
          end

        seeds_hash_to_view(grouped, DIR_COLOR_MAIN)
      end

      def nest_hashs_to_view(nest_hash_array, key1_color, key2_color)
        nest_hash_array.keys.map do |key1|
          [Rainbow(key1).color(key1_color)].concat(
            nest_hash_array[key1].flat_map do |key2, arr|
              [Rainbow(key2).color(key2_color)].push(arr.join(SPACE)).push("\n")
            end
          )
        end
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
      def seeds_hash_to_view(seeds_hash, color_symbol)
        seeds_hash.inject([]) do |result, (key, files)|
          result << Rainbow("#{key}: #{files.size}").color(color_symbol) << files.join(SPACE) << "\n"
        end
      end
    end
  end
end
