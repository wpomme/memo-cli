## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### バージョン
    - gemspecの件が終了したらバージョンを1.0.0にする

### DB・CLI・残タスク
- setup.rbのto_schemaをmodel/以下に入れたい
- Database以下の構成
    - setupは1. create/drop tables, 2. Seeder, 3. schemaの三つに分けられる
- memo help [sub_command]の作成
- モックデータからテストコードの検証を行うようにする
- loaderフォルダについて、フォルダに入れるまでで充分。Loaderモジュールは削除する
    - Loaderに値を入れる場面で、FileSeed, DirectorySeedを使いたい
- View::Listについて、ネストしたハッシュを配列・構造体・集合のどれかを使って直す
    - コードが複雑になってしまったため

## その他やりたいこと
## テスト系
### 型検査・型のテスト・テスト拡張
- Rdocかyard、型検査の導入、coverageの取得
    - coverage: https://docs.ruby-lang.org/ja/latest/library/coverage.html
- e2eテストをコマンドごとに分けて、コマンドごとに実行する場合は、その結果を標準出力に渡すようにする

### expected, actual
- expected, actualを意味的に逆に使っている箇所があるかもしれない
    - 洗い出す

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
