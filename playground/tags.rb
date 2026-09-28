# frozen_string_literal: true

## seed["tags"]についてのplayground
# キーがrel_path、値がtagsのハッシュを作成する
tags_hash = seeds.to_h { |seed| [seed.rel_path, seed.tags] }

total_tag_list2 = seeds.map(&:tags).flatten.uniq

# 要素数
tags_hash.length
# => 133

# tagsの値が空の要素数
tags_hash.group_by { |_, v| v.empty? ? :empty : :exists }[:empty].length
# => 79

# 全てのタグを一次元配列に入れる
all_tag_list = tags_hash.values.reject(&:empty?).flatten

# 全てのタグから重複を排除したタグのリストを作成する
total_tag_list = all_tag_list.uniq

# タグごとの出現頻度をハッシュで返す
frequency_of_each_key = all_tag_list.tally

# 出現回数がキーで、その出現回数に紐付くタグを配列として値とするハッシュを作成する
keys_grouped_by_frequency_hash = frequency_of_each_key.each_with_object({}) { |(k, v), hash| (hash[v] ||= []) << k }

# 見やすくするため、出現頻度を降順にして、二次元配列で返してみる
sorted_keys_grouped_by_frequency_hash = keys_grouped_by_frequency_hash.sort { |a, b| b[0] <=> a[0] }.to_h

p sorted_keys_grouped_by_frequency_hash

# タグごとに紐づくrel_pathを配列で作成する
# 例えば、JavaScriptをタグとして持つrel_pathを抜き出すには
tags_hash.filter { |_k, v| v.include?("CLI") }.keys
# => CLIタグがついているものは、そのCLIコマンドを返してほしい

# タグとそれに紐付くファイル名のハッシュを作成する
tag_file_list_hash = total_tag_list.to_h do |tag|
  [
    tag,
    tags_hash.filter do |_k, v|
      v.include?(tag)
    end
      .keys
  ]
end

# タグとそれに紐付くSeedのリストのハッシュを返す
tag_seed_hash = total_tag_list2.to_h do |tag|
  [
    tag,
    seeds.filter do |seed|
      seed["tags"].include?(tag)
    end
  ]
end

# タグごとの出現頻度をハッシュで著す。frequency_of_each_keyと同じ結果になるはず
frequency_of_each_key2 = tag_file_list_hash.transform_values(&:length)
frequency_of_each_key3 = tag_seed_hash.transform_values(&:length)

p frequency_of_each_key2
p frequency_of_each_key3
