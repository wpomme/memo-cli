## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### 残タスク
- テストコードを作成する
- rubocopのメトリクスによるリファクタリング
- sub_command_parser関連
    - memo help [sub_command]の作成: コマンドごとのヘルプを作成する
- git grep TODOで出てくるTODOを解消していく。また、テストコードのskipを外す
- メソッドの可視性の調査 => 変更、オブジェクトについて、必要なものはfreezeする
- Minitest::Testを継承しているクラス名がタイポしていないかどうかを確認する
- タイポを見つける => 修正する
- Rdocかyardの導入、coverageの取得
    - coverage: https://docs.ruby-lang.org/ja/latest/library/coverage.html
    - simpleCov: https://github.com/simplecov-ruby/simplecov


## その他やりたいこと
### DBに関するクラスの整理
- setup.rbのto_schemaをmodel/以下に入れたい
- Database以下の構成
    - setupは1. create/drop tables, 2. Seeder, 3. schemaの三つに分けられる
    - prepare, serupのところのテストコードを追加する

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
