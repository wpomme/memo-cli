## memo walk CLIを作成するためのplayground
```ruby
# seedsをそのファイルが入っているディレクトリごとにグループ分けしてハッシュにする
group_by = seeds.group_by(&:dir)

# 対象のフォルダについて、親ディレクトリごとにディレクトリをグループ分けしてハッシュ化する
dir_group_by = repo.dir_seeds.group_by(&:parent_dir)

# ディレクトリをキーとして、そのキーに対応するSeedとDirSeedを配列に保存する
# キーがnilのものは大元のディレクトリを指す

merged = dir_group_by.merge(group_by) do |_, dirs, files|
  dirs + files
end

# => これをMemo::ModelにStructとして定義して、その後にwalkを定義する
```
