# frozen_string_literal: true

module Memo
  module View
    class List
      #
      # word [true | String]
      def self.run(word)
        new(word).execute
      end

      def initialize(word)
        @word = normalize(word)
        @target_dirs = Memo::Config.target_dirs
      end

      def execute
        return all_list_to_view if @word == true

        # そのようなディレクトリ名がないというメッセージを表示するのが適切
        return if look_up_from_all_list.empty?

        list_by_dir_to_view
      end

      private

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
        [Rainbow(arr.shift).color(:green), Rainbow(arr.shift).color(:cyan)] << arr.join(' ')
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
        all_list.map do |key, dbl_arr|
          [Rainbow(key).color(:green)].concat(dbl_arr.map do |arr|
            [Rainbow(arr[0]).color(:cyan), arr[1].join(' '), "\n"]
          end)
        end
      end

      # 対象ディレクトリがキーで、二重配列の最初の要素に親ディレクトリ、最後の要素にファイル名を入れたものを返す
      #
      # @return [Hash<String, Array<Array<String, Array<String>>>>]
      def all_list
        grouped_file_seeds.group_by { |(k_arr, _)| k_arr[0] }
          .transform_values do |values|
          values.map do |arr|
            [arr[0].last, arr[1]]
          end
        end
      end

      # 対象ディレクトリと親ディレクトリの配列がキーで、ファイル名の配列が値となるハッシュを返す
      # {[target_dir, parent_rel_path] => [files]}
      def grouped_file_seeds
        Memo::FileLoader.new.file_seeds_light.group_by { |file_seed| [file_seed[:target_dir], file_seed[:parent_rel_path]] }
          .transform_values do |values|
            values.map do |file_seed|
              file_seed[:filename]
            end
          end
      end
    end
  end
end
