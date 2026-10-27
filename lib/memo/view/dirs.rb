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
        @directory_loader.relative_path_hash.transform_values { |paths| paths.join("\n") }
          .map do |key, value|
            [Rainbow("#{key}:").color(DIR_COLOR_MAIN)].push(value).push('')
          end
      end
    end
  end
end
