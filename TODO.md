## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### バージョン
    - gemspecの件が終了したらバージョンを1.0.0にする

## DB / CLIのUI
- DBを作成したら、それに従ってアーキテクチャとCLIのUIを変更する予定
    - CLIについては、基本は作成したFileLoaderを使うのみで、DBに依存しないようにしたい

### DB
1. seedsを作成して、実データとテストデータをDBに入れる
2. db/以下のgit監視を外す
3. database/配下の構成案
    - db.rb => prepare.rbに統合して、connection.rbとする
    - loaderフォルダを作成し、その中にfile_loaderとdirectory_loaderを入れる。serviceのabsolute_pathsはdirectory_loaderの中に入れる
        - ユーザー向けに必要な情報はloader内で作成する。
            - 現状、全てのコマンドがloader内で処理できそう
            - 手始めにmemo dirsをこのdirectory_loaderを使って変更してみたい
                - `ls -R`の表示に倣って、対象ディレクトリごとに、ディレクトリの一覧を表示する
        - ユーザー向けに表示方法を変更する場合は、viewの中で行う
    - setup.rbのto_schemaをmodel/以下に入れたい

### CLI案
- OptionParserなしで実装してもいいかもしれない
    - 使用するオプションが少ない。代わりにサブコマンドで代用しているため。
- getoptlongなどを使ってもいいかもしれない
    - Ruby: https://docs.ruby-lang.org/ja/latest/library/getoptlong.html
    - GNU: https://www.gnu.org/prep/standards/html_node/Command_002dLine-Interfaces.html
- その他コマンドオプションに関する規格などがあればそれに従うのがいいかもしれない

### CLI案２
- tagsのサブコマンドの機能を果たす--count/--empty/--nameの処理を単純にしたい
    - ブロックを渡す処理を消したい。
    - OptionParser.parse(args): memo tags list => {tags: nil, list: nil}っぽいのが返ってくる
        - これを生かすのが良さそう
        - Comamandに渡すときに、[[tags: nil, empty: nil]]のようにして、逆の順番だったらエラーを出すなど
        - --emptyなどの詳細には、tags専用のサブコマンドであることを記載する
            - または、helpのメッセージの出し方を再度考慮する

### 表示系に関するCLI案
- memo list, memo tagsにて、ディレクトリ・タグとファイル名の次に改行を入れたい
    - memo list [DIRS]の場合の表示を変えたい。ファイルの方はより詳細な情報を出したい
    - memo tag [TAG_NAME]も同様

## その他やりたいこと
## テスト系
### 型検査・型のテスト・テスト拡張
- Rdocかyard、型検査の導入、coverageの取得
    - coverage: https://docs.ruby-lang.org/ja/latest/library/coverage.html

### expected, actual
- expected, actualを意味的に逆に使っている箇所があるかもしれない
    - 洗い出す

### 値の検査
- 実装のメソッドをそのままコピーしたテストコードは修正したい
    - 他、古いテストコードのアップデートなど

### モックデータの作成
Rakefileに記載したコードは別のファイルに移動させた方がいいかもしれない

## 機能追加
- 各メモファイルのfront matterにcreated_at, updated_atを挿入する
    - bashと組み合わせてスクリプトのように作成してもいい

- Messageモジュールについて、メッセージ内の文字列を他の変数に変換するメソッドを追加する

## タグ系
1. それぞれのタグによって、特定の機能が欲しい
    a. 例えばタグにCLIとついている場合は、それに紐付くCLIの一覧が見れたら嬉しい
2. タグの英語・日本語の対応表があると嬉しい

## DBの更新
1. 一度データを全て消してから全てのデータを入れ直す
2. 最後にDBのデータをUpdateした時点から、ファイルのCreate, Update, Deleteを検知し、それぞれの更新を行う

### 補完(Completion)
- zshでの補完を考える
    - zsh-completionsのコードを参照すること
    - https://github.com/zsh-users/zsh-completions/blob/master/src/_rev

### その他
- git grep TODOで出てくるTODOを解消していく。また、テストコードのskipを外す
- メソッドの可視性の調査 => 変更、オブジェクトについて、必要なものはfreezeする
