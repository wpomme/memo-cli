# frozen_string_literal: true

module Memo
  class DirectoryLoader
    def directory_path_size
      @directory_path_size ||= absolute_paths.size
    end

    # 対象のディレクトリについて、その中のディレクトリの一覧を配列で返す
    # Configで設定されたディレクトリも含む
    #
    # @return [Array<String>>]
    def absolute_paths
      @absolute_paths ||= relative_path_hash.flat_map do |target_dir, dirs|
        [target_dir].concat(
          dirs.map do |dir|
            File.join(target_dir, dir)
          end
        )
      end
        .uniq
    end

    # キーが設定ファイルで定義されたディレクトリで、そのキーの中のディレクトリの一覧が値となるハッシュを返す
    # 値の方の配列に空文字を入れる。Directoryテーブルのdirectory_pathが空文字の場合は、Configディレクトリを表すため
    #
    # @return [Hash<String, Array<String>>]
    def relative_path_hash(target_dirs = Memo::Config.target_dirs)
      @relative_path_hash ||= directory_tree(target_dirs).transform_values do |dir_node|
        dir_node.keys.flat_map do |key|
          dir_node[key]
        end
          .uniq << ''
      end
    end

    # ディレクトリの階層関係をハッシュで表す
    #
    # @return [Hash<String, Hash>]
    def directory_tree(target_dirs = Memo::Config.target_dirs)
      @directory_tree ||= target_dirs.to_h do |target_dir|
        [target_dir, Dir.glob('**/*/', base: target_dir).group_by do |dir|
          File.dirname(dir) << '/'
        end]
      end
    end

    # 対象のディレクトリをキーとし、その中に入っているディレクトリの一覧を値とするハッシュを返す
    #
    # @return[Hash<String, Array<String>>]
    def directory_seeds_hash(target_dirs = Memo::Config.target_dirs)
      @directory_seeds_hash ||= target_dirs.to_h do |target_dir|
        [target_dir, ['./'].concat(Dir.glob('**/*/', base: target_dir))]
      end
    end
  end
end
