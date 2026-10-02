# frozen_string_literal: true

# タグ系
## seed["tags"]についてのplayground
## キーがrel_path、値がtagsのハッシュを作成する
total_tag_list = seeds.map(&:tags).flatten.uniq

# タグとそれに紐付くSeedのリストのハッシュを返す
tag_seeds_hash = total_tag_list.to_h do |tag|
  [
    tag,
    seeds.filter do |seed|
      seed['tags'].include?(tag)
    end
  ]
end

# タグの出現回数を昇順で返す
count_of_each_tag = tag_seeds_hash.transform_values(&:length)
  .to_a
  # 出現回数が最初の要素とした方が分かりやすいので、キーと値を逆にする
  .map { |(first, last)| [last, first] }
  .sort { |(a_first, _), (b_first, _)| b_first <=> a_first }

# 特定のタグに紐付いているファイル名の一覧を出力する
# CLIと付いているタグは、そのCLIの一覧を出力してみたい
tag_seeds_hash['CLI'].map(&:basename)
# gitと付いているタグは、そのgit commandの一覧を出力してみた
tag_seeds_hash['git'].map(&:basename)
# textと付いているタグをまとめるようなメモファイルが欲しい
tag_seeds_hash['text'].map(&:basename)

[count_of_each_tag]

# 重複の集計
## filenameだけの配列も作っておく
filenames = seeds.map(&:basename)

## 重複しているファイル名と、重複しているSeedを抽出する
seeds.filter { |seed| filenames.count(seed['basename']) > 1 }
