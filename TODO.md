## TODO・IDEA
## TODO
### gemspec
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### 残タスク
- テストコードを作成する
    - 作成方針
    - ViewModel: 値の検査、View: 標準出力へ表示されているかどうか
    - SubCommandParser: 入力値の検査、Command、SubCommand: クラスが呼び出されるかどうか
    - test_loader.rbがあってもいいかもしれない
        - DirとFileの統合テスト
        - Dirの方とFileの方のディレクトリの数は合っているか？など
- rubocopのメトリクスによるリファクタリング
- git grep TODOで出てくるTODOを解消していく。また、テストコードのskipを外す
- メソッドの可視性の調査 => 変更、オブジェクトについて、必要なものはfreezeする
- Minitest::Testを継承しているクラス名がタイポしていないかどうかを確認する
- Rdocかyardの導入、coverageの取得
    - coverage: https://docs.ruby-lang.org/ja/latest/library/coverage.html
    - simpleCov: https://github.com/simplecov-ruby/simplecov
- その他修正点
    - memo.rbのrequire_relativeを簡単にする
    - test/helperを分割する
        - 少なくとも、require部分とhooks部分に分ける
    - memo list [dirs]で、dirsが存在しなかった場合、取りうるディレクトリの一覧を出力する
        - memo list booksと打つと、例外が送出されてしまう。要修正
    - 各クラスの呼び出しについて、簡単のため呼び出すメソッドを特異メソッドにする
        - 今のままでOK: ViewModel
        - 特異メソッドにする: View, Command, SubCommand
        - 未定: SubCommandParser
    - rake e2eを堅牢にする
    - git push前のhooksを作成する

### 残タスク・テストコードの進捗表
- loader
    - [ ]: directory_loader
    - [ ]: file_loader
- SubCommandParser
    - [x]: check
    - [ ]: common
    - [x]: dirs
    - [ ]: help
    - [ ]: list
    - [x]: read
    - [x]: search
    - [x]: tag
    - [ ]: tags
    - [x]: version
- View
    - [ ]: check
    - [x]: dirs
    - [ ]: list
    - [i]: read => あと一つ
    - [ ]: search
    - [x]: tag
    - [ ]: tags
    - [x]: version
- ViewModel
    - [x]: check
    - [ ]: common
    - [x]: dirs
    - [ ]: list
    - [x]: read
    - [i]: search => あと一歩
    - [x]: tag
    - [i]: tags => あと一つ


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
