# frozen_string_literal: true

module Memo
  module ViewModel
    class Check
      include Memo::ViewModel
      include Memo::Message

      def initialize(target_dirs: Memo::Config.target_dirs)
        @target_dirs = target_dirs
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      def execute
        grouped_duplicated_seeds = @file_loader.duplicated_seeds.group_by do |file_seed|
          file_seed[:filename]
        end

        duplicated_filenames_to_view(grouped_duplicated_seeds)
      end

      private

      def duplicated_filenames_to_view(grouped_duplicated_seeds)
        grouped_duplicated_seeds.map do |filename, seeds|
          colored_dirs = seeds.map.with_index(1) do |seed, index|
            dir_color_sub("[#{index}]: #{seed[:parent_directory]}")
          end
          "#{filename}\n#{colored_dirs.join("\n")}"
        end.join("\n\n")
      end
    end
  end
end
