## TODO・IDEA
```
# 内部
## Memoモジュール再編
Memo
## Repository -> ViewModel -> Presenter -> Command
Memo::Repository -> 元データ
Memo::ViewModel -> ユーザー向けのデータ加工。色付けなど。また、RepositoryをPrivateにできるかも。
Memo::Presenter -> データの表示とユーザーメッセージ
Memo::Command -> CLI
Memo::Command::Options::CommandParser -> Memo::CommandParserにする
## 新設
Memo::GroupedFileListを作成した
Memo::UserMessageというモジュールを作成する。ユーザーメッセージを補完する場所
-> PresenterとCommandParserにインクルードして使う
## リネーム
memo/struct.rb -> memo/data_object.rbとかだろうか
Memo::Repository::Entry -> Memo::Seedにする
Memo::MemoFileUtility -> FileUtilityなどにする。テストコードも使うから欲しい。実装上はrepositoryだけでしか使わないかも。
できればMemo -> MemoCliにしたい...

## 分岐対応
README.mdの処理を明確にする
トップレベルのmdファイルの所属ディレクトリが.になってしまうのでmemoとかにしたい
-> @memo_dirの末尾のディレクトリがmemoになるから、それを使いたい

## フォルダ構成や命名規則の変更
word? の文字列チェックを廃止する

# CLI
memo grep # docs 以下について、そのキーワードで全文検索をかける

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

