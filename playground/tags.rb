# frozen_string_literal: true

## seed["tags"]についてのplayground
# キーがrel_path、値がtagsのハッシュを作成する
total_tag_list = seeds.map(&:tags).flatten.uniq

# タグとそれに紐付くSeedのリストのハッシュを返す
tag_seeds_hash = total_tag_list.to_h do |tag|
  [
    tag,
    seeds.filter do |seed|
      seed["tags"].include?(tag)
    end
  ]
end

# タグごとの出現頻度をハッシュで著す。frequency_of_each_keyと同じ結果になるはず
frequency_of_each_key = tag_seeds_hash.transform_values(&:length)

# 出現回数がキーで、その出現回数に紐付くタグを配列として値とするハッシュを作成する
keys_grouped_by_frequency_hash = frequency_of_each_key.each_with_object({}) { |(k, v), hash| (hash[v] ||= []) << k }

# 見やすくするため、出現頻度を降順にして、二次元配列で返してみる
sorted_keys_grouped_by_frequency_hash = keys_grouped_by_frequency_hash.sort { |a, b| b[0] <=> a[0] }.to_h

p sorted_keys_grouped_by_frequency_hash

# 特定のタグに紐付いているファイル名の一覧を出力する
# CLIと付いているタグは、そのCLIの一覧を出力してみたい
tag_seeds_hash["CLI"].map(&:basename)
# gitと付いているタグは、そのgit commandの一覧を出力してみた
tag_seeds_hash["git"].map(&:basename)
# textと付いているタグをまとめるようなメモファイルが欲しい
tag_seeds_hash["text"].map(&:basename)
