# memo
## 使い方
- [自分のメモ帳](https://github.com/wpomme/memorandum) と連動させて使う
- `/memo-cli/exe/memo_env.rb` に`/memorandum/memo` フォルダを指定すれば動く

## コマンド集
```bash
# 作成したメモとそのフォルダの一覧を表示する
memo list

# 作成したメモを表示する
memo read <word>

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

### 開発コマンド
```bash
# コマンドの確認
rake -T

# memo list の実行
rake list

# memo read の実行
# * Rakefile で引数の取り方が分からずmise を使っている
mise read <word>

# テストの実行
rake
```
