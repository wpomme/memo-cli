## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### DB・CLI・残タスク
- setup.rbのto_schemaをmodel/以下に入れたい
- Database以下の構成
    - setupは1. create/drop tables, 2. Seeder, 3. schemaの三つに分けられる
    - prepare, serupのところのテストコードを追加する
- memo help [sub_command]の作成: コマンドごとのヘルプがほしい
- モックデータからテストコードの検証を行うようにする
- 各クラスのrunとexecuteを入れ替える。プライベートにするrunは別の名前にする
- Loaderに値を入れる場面で、FileSeed, DirectorySeedを使いたい
- Viewの課題
    - 共通
        - group_by, transform_valuesの周りの処理が複雑化している
        - メソッドチェーン+ネストを減らす
        - 各メソッドの整理を通じて、ロジック・データ構造・定数の整理を行う
    - Tags
        - タグの整列順を統一・整理すること
    - List
        - :duplicate, :countを作成する
    - Read
        - Serviceのselect_promptをControllerにしたい
    - dirs
        - DirectoryLoader#directory_seeds_hashについて、カレントディレクトリの場合はやはり空文字を入れておく
            - そっちの方がコードが煩雑にならない


## その他やりたいこと
## テスト系
### 型検査・型のテスト・テスト拡張
- Rdocかyard、型検査の導入、coverageの取得
    - coverage: https://docs.ruby-lang.org/ja/latest/library/coverage.html

## 機能追加
- 各メモファイルのfront matterにcreated_at, updated_atを挿入する
    - bashと組み合わせてスクリプトのように作成してもいい
- Messageモジュールについて、メッセージ内の文字列を他の変数に変換するメソッドを追加する

## タグ系
1. それぞれのタグによって、特定の機能が欲しい
    a. 例えばタグにCLIとついている場合は、それに紐付くCLIの一覧が見れたら嬉しい
2. タグの英語・日本語の対応表があると嬉しい

## DBの更新
1. 最後にDBのデータをUpdateした時点から、ファイルのCreate, Update, Deleteを検知し、それぞれの更新を行う

### 補完(Completion)
- zshでの補完を考える
    - zsh-completionsのコードを参照すること
    - https://github.com/zsh-users/zsh-completions/blob/master/src/_rev

### その他
- git grep TODOで出てくるTODOを解消していく。また、テストコードのskipを外す
- メソッドの可視性の調査 => 変更、オブジェクトについて、必要なものはfreezeする
- オプショナル位置引数をキーワード引数に変えていく
- Minitest::Testを継承しているクラス名がタイポしていないかどうかを確認する
- タイポを見つける => 修正する
