## TODO・IDEA
### TODO
### DB連携
- sqlite3とSequelを使う
    - ファイルにタグ付けをする
        - yamlやFront Matterでtagを再現する案もある
        - タグ付けでネットワークのようなデータ構造を作成できないだろうか
        - タグ名の候補
            - CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
            - CLI: File System, Process Management, User Management, Text Processor, Built-in
    - 閲覧履歴などの集計を取る
        - 取得したい集計情報
            - メモの参照回数
            - メモの作成日・最終更新日時・最終アクセス日時
        - 集計のためにmemo statみたいなコマンドを作成するかも
            - ファイル数や行数、コマンドの例の数を拾ってくるようなもの
        - rubocopのメトリクスを測る機能を使いたい
            - `.rubocop.metrics.yaml`のようなものが欲しい
- DBモデル案
    - Memo: memo_id, rel_path, ...
        - メモのリネームや削除があるためIDは自動採番のものを使う


### リファクタリング・修正事項
#### パス名・環境変数系
1. DBと接続するための設定をMemo::Configに入れる

# テスト系
## Rakefileとe2eテスト
- Rakefileで各種コマンドを発行させてe2eテストを作成したい

## 型検査・型のテスト
- Rdocかyard、型検査の導入

## テスト拡張
- coverageを取得する

## モックデータ
    - 欲しいモックデータ
        - @fixed_mock_file = 'diff'
        - @fixed_mock_duplicated_file = 'mise'
            - 別のsetup, teardownを作成するべきだろうか

# その他
### gemspecなどを削除する
    - gemにする必要がない

## CLIの拡張
- `memo walk`でmemoの階層のトップを見せて、プロンプトに従って、フォルダを指定したら、その階層に飛び、ファイルを指定したらreadするようなコマンドが欲しい
    - tagにも応用が効くはず
    - Repositoryでseedにフォルダ階層の追加情報を持たせる？
- ** `memo list <dirs> | fzf | xargs -I{} memo read {}`で選択したメモを読むことができる
    - 例: `memo list cli | fzf | xargs -I{} memo read {}`
    - ** `memo list | fzf | xargs -I{} memo read {}`でも可能
        - `memo list`について、pipeやファイルに出力するとカラーコードが落ちてしまう
        - `memo list | xargs -I@ echo @`などで再現する
            - `Rainbow.enabled`の設定変更が必要？ -> パス名・環境変数系へ

# CLIの自動補完 <= zshを使う？
- どうやるんだろう。zsh限定でいい

# 異なる環境用のlinux containerを作成
    - dotfiles, memorandomの環境構築も行いたい
