## bundle exec irb で調べたこと
- 準備
```bash
## ログイン
bundle exec irb
```

## irbコンソールの中
```irb
# メモフォルダへの絶対パスを返す
dir = Memo::Env.to_memo_dir

# Seedの配列を取得
# TODO: Memo::Model::Seedでもいい気がする
seeds = Memo::Repository.new(dir)

# Repositoryのオブジェクトも作成しておく
repo = Memo::Repository.new(dir)
```

## `seeds = Memo::Repository.new(dir)`についての調査
```irb
## このseedsは配列ではないが、Enumerableではある
repo.is_a?(Array)
=> false
repo.is_a?(Object)
=> true
repo.is_a?(Class)
=> false
repo.is_a?(Enumerable)
=> true

repo.class
=> Memo::Repository

## seedsはMemo::Repositoryクラスのインスタンスである
repo.instance_of?(Memo::Repository)

## オブジェクトのインスタンス変数(例: @foo)はinstance_variablesで調べられる
## 現状、
1.
repo.instance_variables
=> [:@entries]

2.
repo.instance_variables
=> [:@entries]
```

## `entries_grouped_by_dir`についての調査
```irb
## filesをdir名でgroupかしたものの調査
## 返り値をHashにして、値をファイル名の配列か集合にしたかったので
## 次のコマンドだと値が配列になっているものが帰ってくる
repo.entries_grouped_by_dir(repo)["git"].map(&:filename)

## 最後にto_setを付ければ、値が集合になる
repo.entries_grouped_by_dir(repo)["git"].map(&:filename).to_set

## dirでグループ化したデータ構造をStructに持たせる
## まず、グループ化したデータ構造を調べる
grouped = repo.entries_grouped_by_dir(repo)

## 次のようなものが良さそう
def new_grouped_files(grouped)
  grouped.map do |dir, seed|
    Memo::FilesGroupedByDir.new(
      dir: dir,
      file_hash: seed.map{ |seed| {seed.filename => seed.full_path} }
    )
  end
end
```

## Data, Structオブジェクトの使い方に慣れてテストデータを新しく作り直したい
```ruby
## 実データからサンプルデータを取得(三の倍数のデータのみ取得)
repo.filter.each_with_index{|e, i| (i).modulo(3).zero? }
## -> filename, dir, その他ファイルに書き込む内容contentがあればOK
## 今のテストデータの作成法とあんまり変わらない...
```

