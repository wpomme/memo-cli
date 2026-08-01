## bundle exec irb で調べたこと
- 準備
```bash
## ログイン
rake colsole
```

## rake consoleで必要なデータを作成する
```ruby
# メモフォルダへの絶対パスを取得する
dir = Memo::Config.memo_dir

# Repositoryのオブジェクトを作成する
repo = Memo::Repository.new(dir)

# Repository.seedsも取得しておく
seeds = repo.instance_variable_get(:@seeds)
```

## Rainbowで文字に色付け
```ruby
mapper = Memo::Mapper.new(repo)
mapper.colored_dirs
> ["\e[32mmemo\e[0m"
  ...

## 色付けされた文字列はRainbowのインスタンスではなく、単に文字列となる
mapper.colored_dirs.first.instance_of?(Rainbow)
> false
```
