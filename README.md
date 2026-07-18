# memo
## 使い方
- [自分のメモ帳](https://github.com/wpomme/memorandum) と連動させて使う
- `/memo-cli/lib/memo.rb` に`/memorandum/memo` フォルダを指定すれば動く

## コマンド集
```bash
# 作成したメモとそのフォルダの一覧を表示する
memo list

# 存在するディレクトリだけ指定すると、その中のファイルだけが表示される
memo list <dirs>

# 作成したメモを表示する
memo read <word>

# readを省略するとreadと同じ動作になる
memo <word>

# メモ帳のディレクトリの一覧を表示する
memo dirs
```

## セットアップ
```bash
# 1. memo のリポジトリをクローンする
# 2. memorandum のリポジトリをクローンして、memo/exe/memo_env.rb にディレクトリを指定する
# 3. Ruby の動作環境を整えたら、bundle install
bundle install

# 4.1. ローカルでgem をビルドする
bundle exec rake install:local

# 4.2. rake からでも実行可能
rake install:local

# mise も使っているのでmise trust も必要
mise trus

# Result: どこからでもmemo が実行できるはず
memo list
```
