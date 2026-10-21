# memo CLI
## 概要
- 指定したフォルダについて、そのフォルダの中のマークダウンファイルを読み取り、ターミナルで閲覧や文字列検索を行うためのCLI

### 使い方
- [メモ帳](https://github.com/wpomme/memorandum) と連動させて使う
- `/memo-cli/config/yml` に、このメモフォルダを指定する

### コマンドの使い方を調べるには
```bash
# memo cliの使い方を調べる
memo help

# memoだけでもいい
memo
```

## セットアップ
```bash
bundle install

# ローカルでgem をビルドする
bundle exec rake install:local

# mise も使っているのでmise trust も必要
mise trust

# どこからでもmemo が実行できるはず
memo list
```

## 開発向け
### モックファイルの作り方
```bash
# モックを作成
rake seeds

# DBにデータを挿入する
rake db:seeds

## lintで何もなければOK
rake lint

## rubocopでフォーマットする
rake fix
```

### テスト
```bash
rake

# テストが大きく失敗し、ファイルごとにテストを実行したい場合
rake test:file

# それか、ファイルを直接指定してテストを実行する場合
bundle exec ruby -Itest test/memo/test_view.rb

# コマンドごとのE2Eテストも作成した
# ただし正常系しかテストできていない
rake e2e
```

### TODO・アイディアリスト・アーキテクチャ
- `TODO.md`に記載
- アーキテクチャは`architecture.md`に記載
