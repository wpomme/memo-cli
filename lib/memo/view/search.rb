# frozen_string_literal: true

module Memo
  module View
    class Search
      def run(word)
        execute(word)
      end

      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      private

      def execute(word)
        search_result = search_file_seed(word)

        return Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', word) if search_result.all?(&:empty?)

        search_result
      end

      # 検索でヒットした文字列に色をつける
      #
      # @param word [string]
      # @return [Array]
      def search_file_seed(word)
        @file_loader.file_seeds.filter_map do |file_seed|
          file_seed[:file_content].split("\n").filter_map.with_index(1) do |line, idx|
            path = "./#{File.join(file_seed[:parent_rel_path], file_seed[:filename])}.md"
            Memo::Structure::SearchLine.new(path: path, line_number: idx, line: line).to_view(word) if line.include?(word)
          end
        end.reject(&:empty?).flatten
      end
    end
  end
end
