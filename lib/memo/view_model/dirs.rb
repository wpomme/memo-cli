# frozen_string_literal: true

module Memo
  module ViewModel
    class Dirs
      include Memo::ViewModel

      def initialize(target_dirs: Memo::Config.target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
        @directory_seeds_hash = @directory_loader.directory_seeds_hash
      end

      def execute
        @directory_seeds_hash.map do |target_dir, dirs|
          directories = dirs.reject { |rel_path| rel_path == '' }.join("\n")
          "#{dir_color_main(target_dir)}\n#{directories}"
        end.join("\n\n")
      end
    end
  end
end
