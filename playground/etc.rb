# frozen_string_literal: true

# etc: その他のplayground
## seedsからFileデータの集計をとる
stats = seeds.map do |seed|
  File.stat(seed.full_path)
end

## Rainbowで文字に色付け
mapper = Memo::Mapper.new(repo)
mapper.colored_dirs

## 色付けされた文字列はRainbowのインスタンスではなく、単に文字列となる
mapper.colored_dirs.first.instance_of?(Rainbow)

p stats
