# frozen_string_literal: true

module Memo
  module Database
    module Service
      module_function

      def absolute_paths_size
        @absolute_paths_size = absolute_paths.size
      end

      # 対象のディレクトリについて、その中のディレクトリの一覧を配列で返す
      # Configで設定されたディレクトリも含む
      #
      # @return [Array<String>>]
      def absolute_paths
        @absolute_paths = rel_paths_hash.flat_map do |target_dir, dirs|
          [target_dir].concat(
            dirs.map do |dir|
              File.join(target_dir, dir)
            end
          )
        end
      end

      # 相対パスの合計を返す
      #
      # @return [Integer]
      def rel_paths_size
        @rel_paths_size ||= rel_paths_hash.keys.map do |key|
          rel_paths_hash[key].size
        end
          .inject(:+)
      end

      # キーが設定ファイルで定義されたディレクトリで、そのキーの中のディレクトリの一覧が値となるハッシュを返す
      # 値の方の配列に空文字を入れる。Directoryテーブルのdirectory_pathが空文字の場合は、Configディレクトリを表すため
      #
      # @return [Hash<String, Array<String>>]
      def rel_paths_hash(target_dirs = Memo::Config.target_dirs)
        @rel_paths_hash ||= target_dirs.to_h do |root_dir|
          [root_dir, [''].concat(Dir.glob('**/*/', base: root_dir))]
        end
      end
    end
  end
end
