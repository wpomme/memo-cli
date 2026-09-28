## Memo Summary: memoフォルダの集計

### 重複の集計
```ruby
## filenameだけの配列も作っておく
filenames = seeds.map(&:basename)

## 重複しているファイル名と、重複しているSeedを抽出する
seeds.filter{|seed| filenames.count(seed["basename"]) > 1 }
```

### グループ化したファイルの数をHashで取得する
```ruby
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
