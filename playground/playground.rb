# frozen_string_literal: true
#
# 重複の集計
## filenameだけの配列も作っておく
filenames = seeds.map(&:basename)

## 重複しているファイル名と、重複しているSeedを抽出する
seeds.filter { |seed| filenames.count(seed['basename']) > 1 }
