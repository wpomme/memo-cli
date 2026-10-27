# frozen_string_literal: true

module Memo
  module View
    class Dirs
      def run
        execute
      end

      def initialize(target_dirs: Memo::Config.target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
      end

      private

      def execute
        directory_seeds_hash = @directory_loader.directory_seeds_hash

        result = directory_seeds_hash.keys.map do |target_dir|
          [Rainbow(target_dir).color(DIR_COLOR_MAIN)].push(
            directory_seeds_hash[target_dir].reject do |rel_path|
              rel_path == './'
            end
              .join("\n")
          ).push("\n")
        end.flatten

        remove_last_element(result)
      end

      def remove_last_element(arr)
        arr.pop
        arr
      end
    end
  end
end
