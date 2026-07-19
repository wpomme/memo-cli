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

# Entryの配列を取得
# TODO: Memo::Entryでもいい気がする
entries = Memo::Repository.new(dir)

# Repositoryのオブジェクトも作成しておく
repo = Memo::Repository.new(dir)
```

## `entries = Memo::Repository.new(dir)`についての調査
```irb
## このentriesは配列ではないが、Enumerableではある
entries.is_a?(Array)
=> false
entries.is_a?(Object)
=> true
entries.is_a?(Class)
=> false
entries.is_a?(Enumerable)
=> true

entries.class
=> Memo::Repository

## entriesはMemo::Repositoryクラスのインスタンスである
entries.instance_of?(Memo::Repository)

## オブジェクトのインスタンス変数(例: @foo)はinstance_variablesで調べられる
## 現状、
1.
entries.instance_variables
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
repo.entries_grouped_by_dir(entries)["git"].map(&:filename)

## 最後にto_setを付ければ、値が集合になる
repo.entries_grouped_by_dir(entries)["git"].map(&:filename).to_set

## dirでグループ化したデータ構造をStructに持たせる
## まず、グループ化したデータ構造を調べる
grouped = repo.entries_grouped_by_dir(entries)

## 次のようなものが良さそう
def new_grouped_files(grouped)
  grouped.map do |dir, entry|
    Memo::FilesGroupedByDir.new(
      dir: dir,
      file_hash: entry.map{ |entry| {entry.filename => entry.full_path} }
    )
  end
end
```

