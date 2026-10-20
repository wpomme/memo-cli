# frozen_string_literal: true

module Memo
  module NewView
    class List
      #
      # word [true | String]
      def self.run(word)
        new(word).execute
      end

      def initialize(word)
        @word = unify_word(word)
        @file_loader = Memo::Loader::FileLoader.new
        @target_dirs = @file_loader.file_seeds_to_list.keys
      end

      def execute
        # return hash_for_list if @word.empty?
        return nest_hashs_to_view(hash_for_list, :green, :cyan) if @word == true

        # そのようなディレクトリ名がないというメッセージを表示するのが適切
        return unless hash_for_list.values.map(&:keys).flatten.include?(@word)

        # 有効なワードを受け取った場合は、ハッシュのハッシュを返す
        hash_given_word = @target_dirs.filter_map do |target_dir|
          dirs = hash_for_list[target_dir][@word]
          unless dirs.nil?
            h = {}
            h[@word] = dirs
            { target_dir => h }
          end
        end.pop

        nest_hash_to_view(hash_given_word, :green, :cyan)
      end

      private

      def unify_word(word)
        return true if word == true

        return "#{word}/" unless word.end_with?('/')

        word
      end

      # ネストしたハッシュをユーザー向けに表示できるように加工する
      # ネストしたハッシュがあり、最後の値が文字列型の配列である場合に使用する
      # 最初のハッシュのキーが複数ある場合はこちらを使う
      #
      # nest_hash_array [Hash<String, Hash<String, Array<String>>>]
      # key1_color [Symbol]
      # key2_color [Symbol]
      #
      # @return [Array<String>]
      def nest_hashs_to_view(nest_hash_array, key1_color, key2_color)
        nest_hash_array.keys.map do |key1|
          [Rainbow(key1).color(key1_color)].concat(
            nest_hash_array[key1].flat_map do |key2, arr|
              [Rainbow(key2).color(key2_color)].push(arr.join(' ')).push("\n")
            end
          )
        end
      end

      # ネストしたハッシュをユーザー向けに表示できるように加工する
      # 次のようなハッシュを対象とする
      # {"A" => {"B" => ["foo", "bar", "baz"]}}
      def nest_hash_to_view(nest_hash, key1_color, key2_color)
        nest_hash.map do |key1, hash1|
          [Rainbow(key1).color(key1_color)].concat(
            hash1.map do |key2, arr|
              [Rainbow(key2).color(key2_color)].push(arr.join(' '))
            end
          )
        end
      end

      def hash_for_list
        file_seeds = @file_loader.file_seeds_to_list

        to_hash = @target_dirs.to_h do |target_dir|
          [target_dir, file_seeds[target_dir].group_by { |file_seed| file_seed[:parent_rel_path] }]
        end

        @target_dirs.each do |target_dir|
          to_hash[target_dir] = to_hash[target_dir].transform_values do |values|
            values.map do |file_seed|
              file_seed[:filename]
            end
          end
        end

        to_hash
      end
    end
  end
end
