## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### バージョン
    - gemspecの件が終了したらバージョンを1.0.0にする

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

- memo checkのようなCLIが欲しい
    - memo check duplicate => ファイル名の重複の調査

- CLIの自動補完機能
    - bash, zshと連携させてコマンドの自動補完機能を付けてみたい
    - ref?: https://docs.ruby-lang.org/ja/latest/method/OptionParser/i/candidate.html

- Messageモジュールについて、メッセージ内の文字列を他の変数に変換するメソッドを追加する

## タグ系
1. それぞれのタグによって、特定の機能が欲しい
    a. 例えばタグにCLIとついている場合は、それに紐付くCLIの一覧が見れたら嬉しい
2. タグの英語・日本語の対応表があると嬉しい

## 修正箇所
### 表示系
- memo list, memo tagsにて、ディレクトリ・タグとファイル名の次に改行を入れたい
    - memo list [DIRS]の場合の表示を変えたい。ファイルの方はより詳細な情報を出したい
    - memo tag [TAG_NAME]も同様

- Modeo::Seedの属性の整理
    - rel_path, target_dir, parent_dirを上手く統合する
    - 対象のディレクトリが異なる場合の対応が必要
        1. まずparent_dirは絶対パスで保存する
            - `parent_dir = File.dirname(full_path)`としてみる
        2. dir_setも最初は絶対パスで保存して、UIでフォルダ名だけにした方が良さそう
    - <= まずtarget_dirでグループ分けしてから、parent_dirでグループ分けする
        memoとprivate-memoフォルダの末尾のフォルダ名がどちらもmemoでmemo listなどでマージされた結果が表示されてしまう

### DBを作るなら&CLIインターフェイスの再構築
#### DB
1. TODO: ControllerとModelのテストを作成する

2. DBの更新
    1. 一度データを全て消してから全てのデータを入れ直す
    2. 最後にDBのデータをUpdateした時点から、ファイルのCreate, Update, Deleteを検知し、それぞれの更新を行う
#### CLI
- getoptlongなどを使ってもいいかもしれない
    - Ruby: https://docs.ruby-lang.org/ja/latest/library/getoptlong.html
    - GNU: https://www.gnu.org/prep/standards/html_node/Command_002dLine-Interfaces.html
- その他コマンドオプションに関する規格などがあればそれに従うのがいいかもしれない

#### 補完(Completion)
- zshでの補完を考える
    - zsh-completionsのコードを参照すること
    - https://github.com/zsh-users/zsh-completions/blob/master/src/_rev

### その他
- その他、git grep TODOで出てくるTODOを解消していく
- なるべく、コメントに具体的な変数名などを書かないようにしたい
    - 実装の修正があった場合、そのコメントも修正する必要があるため
- メソッドの可視性の調査 => 変更、オブジェクトについて、必要なものはfreezeする
- アーキテクチャ
    - CommandとViewを統合してもいいかもしれない。テストコードがほぼ同じことをしている
        - ファイル生成時間などの書き込みが機能として追加されたらreadとwriteは分けたい

### sub_command_parser
- tagsのサブコマンドの機能を果たす--count/--empty/--nameの処理を単純にしたい
    - ブロックを渡す処理を消したい。
    - OptionParser.parse(args): memo tags list => {tags: nil, list: nil}っぽいのが返ってくる
        - これを生かすのが良さそう
        - Comamandに渡すときに、[[tags: nil, empty: nil]]のようにして、逆の順番だったらエラーを出すなど
        - --emptyなどの詳細には、tags専用のサブコマンドであることを記載する
            - または、helpのメッセージの出し方を再度考慮する

- SubCommandSpecを作成するためのsub_command_factoryのようなクラスかメソッドが必要かもしれない
- `memo tags -h`でmemo tagsのヘルプが見れるようにしたい

### CLIの拡張
1. fzfと連携させればファジーにメモを読み込めたら嬉しい
- リポジトリ配下なら`find . -type f | fzf | xargs -I@ -n1 basename @ ".md" | memo`で読めそう
    - memo readコマンドについて、rel_pathを受け取ったらそのファイルを表示するように改修した上で、fzfと組み合わせればファジーに指定したファイルを読むことができそう
