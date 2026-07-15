## TODO
```
# 内部
Memo::Commandのテストコード
Memo::Docs -> Memo::Memorandumにリネーム
Memo::Docs -> printと出力を分離する

# CLI
memo read <word> で表示したmdファイルに色をつける機能
memo grep   # docs 以下について、そのキーワードで全文検索をかける
memo edit <word> # <word> の編集をする
memo init memorandum とCLI で連携できたら楽 -> /exe 以下に.env を作成してMEMO_DIR=<VAR> <- このVAR に値を設定するなど
memo check memorandum と連携できているかどうか -> memorandum の方にファイルを入れておいて、それがあるかどうかで判断する？

### その他
## 集計情報
memo の一覧を集めたファイルや、memo を参照した日付などの情報を入れておく場所

## DB 連携: SQLite に接続してメモをDBで管理する
- タグ付けなどで便利そう

## Front Matter の追加
- tag: CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
- title: そのファイルの名前を使用する
```

