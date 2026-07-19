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

## 実行環境とmemoのディレクトリパスを記載する場所
1. 実行環境がコマンドラインの実行か、ユニットテストの実行かでディレクトリのパスを分ける必要がある
2. コマンドラインからなら、memoディレクトリを指定する。テストならsetupでtmpdirを作成する
3. 現状は、Memo::Envにmemoディレクトリを書いておいて、テストならRakefileに記載しておいた環境変数で分岐処理を作成する
4. 最終的にはmemo-settings.jsonとかにmemoのディレクトリを記載しておいて、このsettings.jsonを読み取るようにする

## 分岐対応
README.mdの処理を明確にする
トップレベルのmdファイルの所属ディレクトリが.になってしまうのでmemoとかにしたい
-> @memo_dirの末尾のディレクトリがmemoになるから、それを使いたい

# 新規CLI作成
memo grep # docs 以下について、そのキーワードで全文検索をかける

## 情報の集計
- DBとの連携とは別に、ファイル名の重複などを調べておきたい
- 最初はirbから調べて、そのうちクラスを作成する

## DBと集計情報
- DBと連携させて集計情報を取得してみる
memo の一覧を集めたファイルや、memo を参照した日付などの情報を入れておく場所として使う
memo <word>を実行した回数などを計測する？
集計のためにmemo lsみたいなコマンドを作成するかも
その他、タグ付けなどで便利そう
    - Front Matter の追加
    1 tag: CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
    2 title: そのファイルの名前を使用する
```

