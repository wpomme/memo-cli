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
        grouped = @file_loader.duplicated_filenames_seeds.group_by do |file_seed|
          file_seed[:filename]
        end

        result = []

        grouped.each do |filename, seeds|
          colored_dirs = seeds.map.with_index(1) do |seed, index|
            dir_color_sub("[#{index}]: #{seed[:parent_directory]}")
          end
          result << filename << colored_dirs << "\n"
        end

        remove_last_element(result)
      end
    end
  end
end
