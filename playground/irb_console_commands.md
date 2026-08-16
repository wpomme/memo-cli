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

## sqliteに接続
```ruby
require "sequel"

# connect to an in-memory database
DB = Sequel.sqlite

DB.create_table :seeds do
  primary_key :id
  String :rel_path, unique: true, null: false
end

seeds_dataset = DB[:seeds]

seeds.each do |seed|
  seeds_dataset.insert(rel_path: seed.rel_path)
end

seeds_dataset.count
# => 112

# 全てのデータが取り出せる
seeds_dataset.all
```

## seedsからFileデータの集計をとる
```ruby
stats = seeds.map do |seed|
  File.stat(seed.full_path)
end
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
