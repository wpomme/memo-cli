## memo walk CLIを作成するためのplayground
```ruby
# seedsをそのファイルが入っているディレクトリごとにグループ分けしてハッシュにする
grouped_seeds = seeds.group_by(&:dir)

# 対象のフォルダについて、親ディレクトリごとにディレクトリをグループ分けしてハッシュ化する
grouped_dir_seeds = repo.dir_seeds.group_by(&:parent_dir)

# ディレクトリをキーとして、そのキーに対応するSeedとDirSeedを配列に保存する
# キーがnilのものは大元のディレクトリを指す

merged = grouped_dir_seeds.merge(grouped_seeds) do |_, dirs, files|
  dirs.concat(files)
end

# Memo::Repository::WalkSeedHash
# => これをMemo::ModelにStructとして定義して、その後にwalkを定義する
```
