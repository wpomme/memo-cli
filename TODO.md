## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### バージョン
    - gemspecの件が終了したらバージョンを1.0.0にする

## DB / CLIのUI
- DBを作成したら、それに従ってアーキテクチャとCLIのUIを変更する予定
    - Command (<=> SubCommandParser) <=> View <=> Loader(Modelの役割)の構成にする？
    - 更新処理が出来たらCommandの次にControllerを導入してもいいかも

### DB
1. parent_directory_idなど、not null制約を付ける
2. setup.rbのto_schemaをmodel/以下に入れたい
3. Database以下の構成
    - setupは1. create/drop tables, 2. Seeder, 3. schemaの三つに分けられる

### Loader => View => Command
1. FileLoader => file_seeds_hashをプライベートにする
2. DirectoryLoader => クラスにする
3. ユーザー向けに必要な情報はloader内で作成する
4. ユーザー向けに表示方法を変更する場合は、viewの中で行う

### CLI案
- サブコマンドは-h, --helpなどのオプションと同時に使えないようにする
    - その代わり、zshで補完が効くようにする
- サブコマンドの次の引数からコマンドオプションが使えるようにする

- その他の案
    - OptionParserなしで実装してもいいかもしれない
        - 使用するオプションが少ない。代わりにサブコマンドで代用しているため。
    - getoptlongなどを使ってもいいかもしれない
        - Ruby: https://docs.ruby-lang.org/ja/latest/library/getoptlong.html
        - GNU: https://www.gnu.org/prep/standards/html_node/Command_002dLine-Interfaces.html

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
- オプショナル位置引数をキーワード引数に変えていく
- Minitest::Testを継承しているクラス名がタイポしていないかどうかを確認する
- タイポを見つける => 修正する
