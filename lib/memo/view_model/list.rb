# frozen_string_literal: true

module Memo
  module ViewModel
    class List
      include Memo::ViewModel
      include Memo::Message

      def initialize(target_dirs: Memo::Config.target_dirs)
        @target_dirs = target_dirs
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
        @to_relative_dir = @directory_loader.to_relative_dir
      end

      def default
        seeds_grouped_by_directory_to_view(@file_loader.seeds_grouped_by_directory)
      end

      def directory(word)
        found = look_up_from_dirs(normalize(word))

        return NO_DIRECTORIES.gsub('dir', word) if found.nil?

        list_by_directory_to_view(found)
      end

      private

      def list_by_directory_to_view(found)
        filtered_seeds = filtered_seeds_by_directory(found)

        target_dir = dir_color_sub(filtered_seeds[0][:target_dir])
        relative_path = dir_color_main(filtered_seeds[0][:relative_path])
        filenames = filtered_seeds.map do |seed|
          seed[:filename]
        end.join(SPACE)

        "#{target_dir}\n#{relative_path}\n#{filenames}"
      end

      # ある特定のparent_directoryが親であるseedsを返す
      def filtered_seeds_by_directory(word)
        @file_loader.file_seeds.filter do |seeds|
          seeds[:parent_directory] == word
        end
      end

      # wordに該当するディレクトリが存在するかどうかをチェックする
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
