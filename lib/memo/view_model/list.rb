# frozen_string_literal: true

module Memo
  module ViewModel
    class List
      include Memo::ViewModel

      def initialize(target_dirs: Memo::Config.target_dirs)
        @target_dirs = target_dirs
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
        @to_relative_dir = @directory_loader.to_relative_dir
      end

      def execute(word)
        list_by_dir_to_view(word)
      end

      def default
        result = []

        # NOTE: memo tags -eと同じロジックになった
        @file_loader.seeds_grouped_by_directory.each do |target_dir, seed_hash|
          render_hash = {}

          seed_hash.each do |dir, seeds|
            filenames = seeds.map do |seed|
              seed[:filename]
            end

            render_hash[dir] = filenames.join(SPACE)
          end

          result << dir_color_sub(target_dir)

          render_hash.each do |dir, filenames|
            result << dir_color_main(dir)
            result << filenames
            result << "\n"
          end
        end

        remove_last_element(result)
      end

      def duplicate
        grouped = @file_loader.duplicated_filenames_seeds.group_by do |file_seed|
          file_seed[:filename]
        end

        result = []

        grouped.each do |filename, seeds|
          colored_dirs = seeds.map.with_index(1) do |seed, index|
            dir_color_sub("[#{index}]: #{seed[:parent_directory]}")
          end
          result << filename
          result << colored_dirs
          result << "\n"
        end

        remove_last_element(result)
      end

      def directory(word)
        normalized = normalize(word)

        found = look_up_from_dirs(normalized)

        # そのようなディレクトリ名がないというメッセージを表示するのが適切
        return if found.nil?

        result = []

        filtered_seeds = @file_loader.seeds_by_parent_directory(found)

        # target_dirとrelative_pathは全てのseedsで同じ値になる
        result << dir_color_sub(filtered_seeds[0][:target_dir])
        result << dir_color_main(filtered_seeds[0][:relative_path])

        result << filtered_seeds.map do |seed|
          seed[:filename]
        end.join(SPACE)

        result
      end

      private

      # memo list [word]が入力されたとき、まずwordに該当するディレクトリが存在するかどうかをチェックする
      # wordが絶対パスか相対パスでマッチすれば、そのディレクトリの絶対パスを返す
      # なければnilを返す
      #
      # @return [String | nil]
      def look_up_from_dirs(word)
        found = @to_relative_dir.find do |k, v|
          k == word || v == word
        end

        return found[0] unless found.nil?

        nil
      end

      # 検索文字列の名寄せを行う
      def normalize(word)
        return "#{word}/" unless word.end_with?('/')

        word
      end
    end
  end
end
