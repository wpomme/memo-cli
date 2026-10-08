# frozen_string_literal: true

## bundle exec irb で調べたこと
## ログイン
bundle exec irb

## rake consoleで必要なデータを作成する
# メモフォルダへの絶対パスを取得する
target_dirs = Memo::Config.target_dirs

# Repositoryのオブジェクトを作成する
repo = Memo::Repository.new(target_dirs)

# Repository.seedsも取得しておく
file_seeds = repo.instance_variable_get(:@file_seeds)
dir_seeds = repo.instance_variable_get(:@dir_seeds)

mapper = Memo::Mapper.new(repo)

## dir_setの今後
dir_seeds
  # 絶対パスを保存したい
  .map(&:full_path)
  # memo listに入れるディレクトリ名はbasenameの方が簡単でいいかも
  .map { |dir| File.basename(dir) }

dir_set = @repo.dir_set
dir_basename_hash = dir_set.to_h { |dir| [dir, File.basename(dir)] }
filtered_dirs = dir_basename_hash.filter { |_, v| v == dir }.keys

[file_seeds, dir_seeds, mapper, filtered_dirs]
