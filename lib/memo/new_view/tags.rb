# frozen_string_literal: true

module Memo
  module NewView
    class Tags
      #
      # word [true | String]
      def self.run(option)
        new(option).execute
      end

      def initialize(option)
        @option = option
        @file_loader = Memo::Loader::FileLoader.new
      end

      def execute
        tag_files_hash = @file_loader.tag_files_hash
        tag_files_size = @file_loader.sorted_tag_files_size

        return seeds_hash_to_view(tag_files_hash, :aqua) if @option == true

        return hash_to_view(tag_files_size) if @option == :count

        @file_loader.sorted_tags if @option == :name
      end

      private

      def hash_to_view(hash)
        hash.map do |k, v|
          ["#{k}: #{v}"]
        end
      end

      # TODO: Strategyに移動する
      # グループ化されたSeedのハッシュについて、グループごとのファイル名を文字列にして返す
      #
      # @param seeds_hash [Hash<String, Array<Seed>>] 文字列がキーで、値がSeedの配列となるハッシュ
      # @param color_symbol [Symbol] キーの色付けを指定する
      # @return [Array<String>]
      def seeds_hash_to_view(seeds_hash, color_symbol)
        seeds_hash.inject([]) do |result, (key, files)|
          result << Rainbow("#{key}: #{files.size}").color(color_symbol) << files.join(INDENT) << "\n"
        end
      end
    end
  end
end
