# frozen_string_literal: true

module Memo
  module ViewModel
    class Dirs
      include Memo::ViewModel

      def initialize(target_dirs: Memo::Config.target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
      end

      def execute
        directory_seeds_hash = @directory_loader.directory_seeds_hash

        result = []

        directory_seeds_hash.each_key do |target_dir|
          directories = directory_seeds_hash[target_dir].reject { |rel_path| rel_path == '' }.join("\n")
          result << dir_color_main(target_dir) << directories << "\n"
        end

        remove_last_element(result)
      end
    end
  end
end
