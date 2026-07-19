## Memo Summary: memoフォルダの集計

### 重複の集計
```irb
## Repositoryからファイル名と親ディレクトリを配列の組で抜き出す
file_seed = repo.map {|e| [e.filename, e.dir] }

## 配列の最初の方でmapしてcountを使うと重複しているファイルがわかる
## * 現在、mise.mdは二つある
file_seed.map(&:first).count("mise")
# > return 2

## filenameだけの配列も作っておく
filenames = file_seed.map(&:first)

## これで重複しているファイル名と、そのファイルが所属するディレクトリが取り出せる
file_seed.filter{|e| filenames.count(e.first) > 1 }
## > return [["diff", "cli"], ["mise", "cli"], ["diff", "git"], ["mise", "setting"]]
```

### グループ化したファイルの数をHashで取得する
```
# 全体のファイルの数
repo.count
## > return 95

# ディレクトリでグループ化
grouped_hash = repo.group_by(&:dir)

## ディレクトリに所属するファイルの数
## mapを使うと配列の中に入ってしまう
grouped_hash.map{|k, v| {k => v.count}}

## Hashのまま値を変形するにはtransform_valuesを使う
## これは便利だ！
grouped_hash.transform_values(&:count)
## > {"memo" => 5, ...
```
