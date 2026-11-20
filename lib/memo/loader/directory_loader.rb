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

    def to_relative_dir
      directory_seeds.to_h do |seed|
        [seed[:absolute_path], seed[:relative_path]]
      end
    end

    # 対象のディレクトリについて、その中のディレクトリの一覧を配列で返す
    # Configで設定されたディレクトリも含む
    #
    # @return [Array<String>>]
    def absolute_paths
      directory_seeds.map do |seeds|
        seeds[:absolute_path]
      end
    end

    # 対象のディレクトリをキーとし、その中に入っているディレクトリの一覧を値とするハッシュを返す
    #
    # @return[Hash<String, Array<String>>]
    def directory_seeds_hash
      result = {}

      directory_seeds.each do |seed|
        (result[seed[:target_dir]] ||= []) << seed[:relative_path]
      end

      result
    end

    # :target_dir, :absolute_path, :relative_pathからなる構造体を返す
    def directory_seeds
      @directory_seeds ||= @target_dirs.flat_map do |target_dir|
        seeds = Dir.glob('**/*/', base: target_dir).map do |rel_path|
          absolute_path = File.join(target_dir, rel_path)

          Structure::DirectorySeed.new(target_dir, absolute_path, rel_path)
        end
        [Structure::DirectorySeed.new(target_dir, "#{target_dir}/", '')].concat(seeds)
      end
    end
  end
end
