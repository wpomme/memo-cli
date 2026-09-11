# memo
## 使い方
- [自分のメモ帳](https://github.com/wpomme/memorandum) と連動させて使う
- `/memo-cli/lib/memo.rb` に`/memorandum/memo` フォルダを指定すれば動く

## コマンドの使い方を調べるには
- memo help
```bash
# memo cliの使い方を調べる
memo help
```

## セットアップ
```bash
# 1. memo のリポジトリをクローンする
# 2. memorandum のリポジトリをクローンして、memo/exe/memo_env.rb にディレクトリを指定する
# 3. Ruby の動作環境を整えたら、bundle install
bundle install

# 4.1. ローカルでgem をビルドする
bundle exec rake install:local

# mise も使っているのでmise trust も必要
mise trust

# Result: どこからでもmemo が実行できるはず
memo list
```
