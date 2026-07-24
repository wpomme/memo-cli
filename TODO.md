## TODO・IDEA
```
## TODO
## Rakefileとe2eテスト
Rakefileで各種コマンドを発行させてe2eテストを作成したい

## 分岐対応
- README.md除外対応
- トップディレクトリ -> 対象のディレクトリの末尾
    -テストコードで明確にしたい

## リネーム・構造変更
1. Memo::Env -> Memo::Configにする？
2. メソッドは今のままでOK

# CLI作成・改修
memo grep # docs 以下について、そのキーワードで全文検索をかける
memo dirs # dirsの末尾のディレクトリで検索できるようにしたい、しかし名前が重複しそう
          # トップレベルのディレクトリをmemoにしているように、重複していたら通称を付けるとか

#CLIの自動補完
- どうやるんだろう。zsh限定でいい

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

