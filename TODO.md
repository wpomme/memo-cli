## TODO・IDEA
```
# 内部
## テストコード
private methodからクラスメソッドのテストに移行する
load_entriesの処理を分けてもいいかも。重要な処理だから。
- load_entriesをデータよりの処理にして、今のDocsをコマンドよりの処理にする感じ

Memo
Memo::MemoFileUtility -> FileUtility にする
Memo::Repository -> 元データ
Memo::ViewModel -> データ加工?
Memo::Presenter -> 色付けやputs
Memo::Command -> CLI
Memo::Command::Options::CommandParser -> これにリネームする

## 分岐対応
README.mdの処理を明確にする
トップレベルのmdファイルの所属ディレクトリが.になってしまうのでmemoとかにしたい
-> @memo_dirの末尾のディレクトリがmemoになるから、それを使いたい

## フォルダ構成や命名規則の変更
Memo -> MemoCliにしてMemoCli::Memoのようにした方が良さそう
word? の文字列チェックを廃止する

# CLI
memo read <word> で表示したmdファイルに色をつける機能
memo grep # docs 以下について、そのキーワードで全文検索をかける
memo edit <word> # <word> の編集をする
# いらないかも
# memo init memorandum とCLI で連携できたら楽 -> /exe 以下に.env を作成してMEMO_DIR=<VAR> <- このVAR に値を設定するなど
# memo check memorandum と連携できているかどうか -> memorandum の方にファイルを入れておいて、それがあるかどうかで判断する？

### その他
## 集計情報
memo の一覧を集めたファイルや、memo を参照した日付などの情報を入れておく場所
memo <word>を実行した回数などを計測する？

## DB 連携: SQLite に接続してメモをDBで管理する
- タグ付けなどで便利そう

## Front Matter の追加
- tag: CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
- title: そのファイルの名前を使用する
```

