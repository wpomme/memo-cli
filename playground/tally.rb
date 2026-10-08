# frozen_string_literal: true

## ファイルが作成された時間を取得して、昇順に並べる
btimes = file_seeds
  .map { |seed| [seed.rel_path, File.birthtime(seed.full_path)] }
  .sort { |(_, a_second), (_, b_second)| b_second <=> a_second }

## 最終更新時間
mtimes = file_seeds
  .map { |seed| [seed.rel_path, File.mtime(seed.full_path)] }
  .sort { |(_, a_second), (_, b_second)| b_second <=> a_second }

[btimes, mtimes]
