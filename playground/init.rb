# frozen_string_literal: true

## bundle exec irb で調べたこと
## ログイン
bundle exec irb

## rake consoleで必要なデータを作成する
# メモフォルダへの絶対パスを取得する
# dir = Memo::Config.memo_dir
dirs = Memo::Config.target_dirs

# Repositoryのオブジェクトを作成する
# repo = Memo::Repository.new(dir)
repo = Memo::Repository.new(dirs)

# Repository.seedsも取得しておく
seeds = repo.instance_variable_get(:@seeds)
dir_seeds = repo.instance_variable_get(:@dir_seeds)

Memo::Mapper.new(repo)

p seeds, dir_seeds
