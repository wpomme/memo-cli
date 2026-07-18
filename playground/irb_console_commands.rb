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

## 調べたこと
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

# モジュールやクラスのことを調べてみる
```irb
## モジュール
## モジュールはインスタンスを生成できないことに注意！
## Module#instance_methodsで、そのモジュールのインスタンスメソッドを調べられる
Memo::MemoFileUtility.instance_methods

## モジュールからミックスインされているメソッドを探して使用する方法
## 経緯: モジュールから直接メソッドを取り出すのが面倒だった
## やり方:
## 継承されているオブジェクトobjについて、存在すれば見つかる
obj.methods.find{|m| m == :method_I_want_to_use }
=> :method_I_want_to_use

## これで使いたいメソッドが使える
repo.method_I_want_to_use
```

```irb
## filesをdir名でgroupかしたものの調査
## 返り値をHashにして、値をファイル名の配列か集合にしたかったので
## 次のコマンドだと値が配列になっているものが帰ってくる
repo.entries_grouped_by_dir(entries)["git"].map(&:filename)

## 最後にto_setを付ければ、値が集合になる
repo.entries_grouped_by_dir(entries)["git"].map(&:filename).to_set
```

```irb
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

# ディレクトリをキーとして、そのディレクトリに所属するファイルのEntryを保存する
# Memo::MemoFileUtility.grouped_by_dir と同じ実装
entries.group_by(&:dir)

# データ構造はHashである
entries.group_by(&:dir).is_a?(Hash)
# -> Hash

# 全てのフルパスを取得
entries.map(&:full_path)

# ファイル名だけ取得(Entryの:filenameを使えば取得できるか...)
entries.map(&:full_path).map{|path| File.basename(path, '.md')}

# ソートしたら、重複している項目が目視で分かる
full_paths.sort

# メモ内のファイルを全文表示する
# irbだと表示されない
# full_paths.each do |full_path|
#   File.readlines(full_path, chomp: true)
# end

