# frozen_string_literal: true

module Memo
  module View
    class List
      include Memo::View

      def run(word)
        execute(word)
      end

      def initialize(target_dirs: Memo::Config.target_dirs)
        @file_loader = Memo::FileLoader.new(target_dirs: target_dirs)
      end

      private

      # TODO: -d/--duplicateと-c/--countの場合も作成する
      #  -d: 重複しているファイル名を出力する
      #  -c: ディレクトリごとのファイルについて、ファイルの数も出力する
      def execute(word)
        return all_list_to_view if word == true

        @word = normalize(word)

        # そのようなディレクトリ名がないというメッセージを表示するのが適切
        return if look_up_from_all_list.empty?

        list_by_dir_to_view
      end

      # 検索文字列の名寄せを行う
      # また、引数なしの場合はbooleanのtrueが来るので、そちらの対応も行う
      def normalize(word)
        return true if word == true

        return "#{word}/" unless word.end_with?('/')

        word
      end

      # memo list [word]が入力されたときに、look_up_from_all_listに色付けをして返すメソッド
      def list_by_dir_to_view
        arr = look_up_from_all_list.flatten
        [dir_color_main(arr.shift), dir_color_sub(arr.shift)] << arr.join(SPACE)
      end

      # wordが入力された場合、ファイルごとの親ディレクトリと名前が一致すれば値を返す
      # 一致しなければ空の配列を返す
      #
      def look_up_from_all_list
        all_list.filter_map do |key, values|
          files = values.filter do |dir_and_files|
            dir_and_files[0] == @word
          end
          [key, files] unless files.empty?
        end
      end

      # memo listが入力されたときに、all_listを色付けして返すメソッド
      def all_list_to_view
        result = all_list.map do |key, dbl_arr|
          [dir_color_main(key)].concat(dbl_arr.map do |arr|
            [dir_color_sub(arr[0]), arr[1].join(SPACE), "\n"]
          end)
        end.flatten

        remove_last_element(result)
      end

      # NOTE: 配列となっているキーについて、表示で使いやすいように親ディレクトリの方を値に移動させる
      # 対象ディレクトリがキーで、二重配列の最初の要素に親ディレクトリ、最後の要素にファイル名を入れたものを返す
      #
      # @return [Hash<String, Array<Array<String, Array<String>>>>]
      def all_list
        result = {}

        grouped_file_seeds.each_key do |key_arr|
          filenames = grouped_file_seeds[key_arr]
          (result[key_arr[0]] ||= []) << [key_arr[1], filenames]
        end

        result
      end

      # NOTE: ファイル名が重複しないように、対象ディレクトリと親ディレクトリの両方でキーを作成する必要がある
      # 対象ディレクトリと親ディレクトリの配列がキーで、ファイル名の配列が値となるハッシュを返す
      # {[target_dir, parent_rel_path] => [files]}
      def grouped_file_seeds
        result = {}

        @file_loader.file_seeds_light.each do |file_seed|
          (result[[file_seed[:target_dir], file_seed[:parent_rel_path]]] ||= []) << file_seed[:filename]
        end

        result
      end
    end
  end
end
