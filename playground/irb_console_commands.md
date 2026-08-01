## bundle exec irb で調べたこと
- 準備
```bash
## ログイン
## 環境変数を設定していないとアプリが中断してしまう
rake colsole
```

## irbコンソールの中
```irb
# メモフォルダへの絶対パスを返す
dir = Memo::Config.memo_dir

# Repositoryのオブジェクトも作成しておく
repo = Memo::Repository.new(dir)

# モックデータ取得のためにattr_reader :seedsとしてある
# モックデータ作成のためにseedsを取得する
seeds = repo.seeds
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
