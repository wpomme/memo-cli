## TODO・IDEA
### TODO
### DB連携
- 次の理由でDBと連携したい。sqlite3とSequelを使う
    - ファイルにタグ付けをする
        - yamlやFront Matterでtagを再現する案もある
        - タグ付けでネットワークのようなデータ構造を作成できないだろうか
        - タグ名の候補
            - CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
    - 閲覧履歴などの集計を取る
        - 取得したい集計情報
            - メモの参照回数
                - (できれば)メモのどこを参照したか、など
                - Markdownのコードブロックの中を見て、コマンドとそのコマンドのコメント行を抜き出せないだろうか
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
2. Rainbow.enabledをdisabledにしたい
    - https://github.com/ku1ik/rainbow#configuration

# テスト系
## Rakefileとe2eテスト
- Rakefileで各種コマンドを発行させてe2eテストを作成したい

## 型検査・型のテスト
- Rdocかyard、型検査の導入

## テスト拡張
- coverageを取得する

## モックデータ
    - @fixed_mock_file = 'diff'が欲しい
        - 別のsetup, teardownを作成するべきだろうか

# その他
### gemspecなどを削除する
    - gemにする必要がない

## CLIの拡張
- サブコマンドだけでなくオプションも使えるようにする
    - `memo -r grep`など
- ** `memo list <dirs> | fzf | xargs -I{} memo read {}`で選択したメモを読むことができる
    - 例: `memo list cli | fzf | xargs -I{} memo read {}`
    - ** `memo list | fzf | xargs -I{} memo read {}`でも可能
        - `memo list`について、pipeやファイルに出力するとカラーコードが落ちてしまう
            - `Rainbow.enabled`の設定変更が必要？ -> パス名・環境変数系へ

## ファイル名重複問題
    - 二つ程度の重複なら、二つとも表示した方が早い
    - 三つ以上になると、選択したい
1. memo readとmemo dirsでファイル名が重複している場合の改修
2. memo readはどちらを見るかを選択する方針にするか、単純に二つのファイルを表示するか
3. memo dirsは、まずdirsの末尾だけで検索できるようにしたいのだが、そうすると名前が重複しそう
4. その場合は、どちらを見るかを選択する方針にするか、単純に二つともディレクトリを表示するか
5. その他、名前の重複のために、モックデータの作成時に、ヒアドキュメントの名前が重複する

# CLIの自動補完 <= zshを使う？
- どうやるんだろう。zsh限定でいい

# 異なる環境用のlinux containerを作成
    - dotfiles, memorandomの環境構築も行いたい
