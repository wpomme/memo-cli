# frozen_string_literal: true

module Memo
  class DirectoryLoader
    def initialize(target_dirs: Memo::Config.target_dirs)
      @target_dirs = target_dirs
    end

    # Database::Controller::Directoryのテストコードで使用する
    def directory_path_size
      @directory_path_size ||= absolute_paths.size
    end

    # 対象のディレクトリについて、その中のディレクトリの一覧を配列で返す
    # Configで設定されたディレクトリも含む
    #
    # @return [Array<String>>]
    def absolute_paths
      @absolute_paths ||= directory_seeds_hash.keys.map do |target_dir|
        directory_seeds_hash[target_dir].map do |rel_path|
          File.join(target_dir, rel_path == './' ? '' : rel_path)
        end
      end.flatten
    end

    # 対象のディレクトリをキーとし、その中に入っているディレクトリの一覧を値とするハッシュを返す
    #
    # @return[Hash<String, Array<String>>]
    def directory_seeds_hash
      @directory_seeds_hash ||= @target_dirs.to_h do |target_dir|
        [target_dir, ['./'].concat(Dir.glob('**/*/', base: target_dir))]
      end
    end
  end
end
