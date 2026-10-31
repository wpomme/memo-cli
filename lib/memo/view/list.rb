# frozen_string_literal: true

module Memo
  module View
    class List
      include Memo::View

      def run(word)
        execute(word)
      end

      def initialize(target_dirs: Memo::Config.target_dirs)
        @target_dirs = target_dirs
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
        @directory_loader = Memo::DirectoryLoader.new(target_dirs: target_dirs)
        @to_relative_dir = @directory_loader.to_relative_dir
      end

      private

      # TODO: -d/--duplicateと-c/--countの場合も作成する
      #  -d: 重複しているファイル名を出力する
      #  -c: ディレクトリごとのファイルについて、ファイルの数も出力する
      def execute(word)
        return all_list_to_view if word == true

        list_by_dir_to_view(word)
      end

      def list_by_dir_to_view(word)
        normalized = normalize(word)

        found = look_up_from_dirs(normalized)

        # そのようなディレクトリ名がないというメッセージを表示するのが適切
        return if found.nil?

        filtered = filter_all_list(found)

        list_to_view_by_filtered(filtered)
      end

      # memo list [word]が入力されたときに、look_up_from_all_listに色付けをして返すメソッド
      def list_to_view_by_filtered(filtered)
        [dir_color_main(filtered.shift), dir_color_sub(@to_relative_dir[filtered.shift])] << filtered.join(SPACE)
      end

      # wordに従って見つかったディレクトリの文字列を引数にとり、
      def filter_all_list(found)
        all_list.filter_map do |target_dir, values|
          dir_and_files = values.find do |arr|
            arr[0] == found
          end
          [target_dir, dir_and_files]
        end
          .flatten
      end

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

      # memo listが入力されたときに、all_listを色付けして返すメソッド
      def all_list_to_view
        result = all_list.map do |key, dir_and_files|
          colored = dir_and_files.map do |(dir, files)|
            [dir_color_sub(@to_relative_dir[dir]), files.join(SPACE), "\n"]
          end

          [dir_color_main(key)].concat(colored)
        end.flatten

        remove_last_element(result)
      end

      # memo listコマンドが入力された場合の、描画のためのデータを作成する
      # 対象ディレクトリがキーで、値については配列を使う
      # 配列の第一引数が、ファイル名の親ディレクトリで、第二引数がファイル名一覧の配列
      #
      # @return [Hash<String, Array<String, Array<String>>>]
      def all_list
        result = {}

        parent_directory_to_filenames.each do |parent_dir, filenames|
          target_dir = @directory_loader.to_target_dir[parent_dir]
          (result[target_dir] ||= []) << [parent_dir, filenames]
        end

        result
      end

      # 親ディレクトリがキーで、その中のファイル名の一覧が配列となるハッシュ
      def parent_directory_to_filenames
        result = {}

        @file_loader.file_seeds.each do |file_seed|
          (result[file_seed[:parent_directory]] ||= []) << file_seed[:filename]
        end

        result
      end
    end
  end
end
