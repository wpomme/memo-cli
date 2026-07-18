## TODO・IDEA
```
## Memoのフォルダ構成・命名規則変更
- Memo::Command::Options::CommandParser -> Memo::CommandParserにする
    - 必要になったらOptionsモジュールを作成する
## 新設
Memo::GroupedFileListを作成した
Memo::UserMessageというモジュールを作成する。ユーザーメッセージを補完する場所
-> PresenterとCommandParserにインクルードして使う
## リネーム
memo/struct.rb -> memo/data_object.rbとかだろうか
Memo::Repository::Entry -> Memo::Seedにする。現行のmemo/struct.rbに移動する
Memo::MemoFileUtility -> FileUtilityなどにする。テストコードにも使うから欲しい。実装上はrepositoryだけでしか使わないかも。
できればMemo -> MemoCliにしたい...

## Rakefileとe2eテスト
Rakefileで各種コマンドを発行させてe2eテストを作成したい

## 分岐対応
README.mdの処理を明確にする
トップレベルのmdファイルの所属ディレクトリが.になってしまうのでmemoとかにしたい
-> @memo_dirの末尾のディレクトリがmemoになるから、それを使いたい

# 新規CLI作成
memo grep # docs 以下について、そのキーワードで全文検索をかける

## DBと集計情報
- DBと連携させて集計情報を取得してみる
memo の一覧を集めたファイルや、memo を参照した日付などの情報を入れておく場所として使う
memo <word>を実行した回数などを計測する？
その他、タグ付けなどで便利そう
    - Front Matter の追加
    1 tag: CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
    2 title: そのファイルの名前を使用する
```

