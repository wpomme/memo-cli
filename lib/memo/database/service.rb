# frozen_string_literal: true

module Memo
  module Database
    module Service
      module_function

      # 対象のディレクトリについて、その中のディレクトリの一覧を配列で返す
      # Configで設定されたディレクトリも含む
      #
      # @return [Array<String>>]
      def absolute_paths
        rel_paths_hash.flat_map do |target_dir, dirs|
          [target_dir].concat(
            dirs.map do |dir|
              File.join(target_dir, dir)
            end
          )
        end
      end

      def rel_paths_size
        @rel_paths_size ||= rel_paths_hash.inject(0) do |ret, (_, v)|
          ret + v.size
        end
      end

      # キーが設定ファイルで定義されたディレクトリで、そのキーの中のディレクトリの一覧が値となるハッシュを返す
      #
      # @return [Hash<String, Array<String>>]
      def rel_paths_hash(target_dirs = Memo::Config.target_dirs)
        @rel_paths_hash ||= target_dirs.to_h do |root_dir|
          [root_dir, Dir.glob('**/*/', base: root_dir)]
        end
      end
    end
  end
end
