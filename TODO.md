## TODO・IDEA
### TODO
### 情報の集計
- DBとの連携とは別に、ファイル名の重複などを調べておきたい
- 最初はirbから調べて、そのうちクラスを作成する

### tag CLIとDB(WIP)
    - とりあえずmemo, memo-tag, tagの三つからなるテーブルを作成してみる？
    - 一旦、memoはseedの情報を全て入れる
    - タグ付けでネットワークのようなデータ構造を作成できないだろうか
#### タグ名候補
    - CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
- tag CLI案
```bash
CREATE
memo tag add <tag>
=> 新しくタグを追加する
memo tag add <memo> <tag>
=> メモにタグを追加する

READ
memo tag list <tag>
=> そのタグが付けられたメモの一覧を返す

DELETE
memo tag delete <memo> <tag>
=> メモからタグを削除する
memo tag delete <tag>
=> タグを削除する
    - タグ付けされたファイルがない場合
```

### DBと集計情報
- 取得したい集計情報
    - メモの参照回数
        - (できれば)メモのどこを参照したか、など
        - Markdownのコードブロックの中を見て、コマンドとそのコマンドのコメント行を抜き出せないだろうか
    - メモの作成日・最終更新日時・最終アクセス日時
- 集計のためにmemo statみたいなコマンドを作成するかも
    - ファイル数や行数、コマンドの例の数を拾ってくるようなもの
- rubocopのメトリクスを測る機能を使いたい
    - `.rubocop.metrics.yaml`のようなものが欲しい

## 後で対応
## リファクタリング・修正事項

# テスト系
## Rakefileとe2eテスト
- Rakefileで各種コマンドを発行させてe2eテストを作成したい

## 型検査・型のテスト
- Rdocかyard、または型検査の導入

## テスト拡張
- coverageを取得する

## Repository#load対応
## 分岐対応
    - README.md除外対応
    - トップディレクトリ -> 対象のディレクトリの末尾
    - Repositoryのseedsをプライベートにする
        -テストコードで明確にしたい
            - load独自のモックデータを作成する

## モックデータ
    - モックデータの変数を`@test_`にしたい
    - @fixed_mock_file = 'diff'が欲しい
        - 別のsetup, teardownを作成するべきだろうか

# その他
## プライベートgem
- gemにするならプライベートにする

## CLIの拡張
- サブコマンドだけでなくオプションも使えるようにする
    - `memo -r grep`など

# パス名・環境変数系
## リネーム・構造変更
1. Memo::Env -> Memo::Configにする？
2. メソッドは今のままでOK
3. パス名・環境変数に対応するためにdotenvの導入
    - dotenvよりmemo_path.rbとmemo_path.sample.rbのようなものを作成して、memo_path.rbはgitで管理しない、の方が良さそう
    - config/memo_path.rbとmemo_path.sample.rbを作成して、lib/env.rb(config.rb)からmemo_path.rbを読み取るのが良さそう
    - memo initでmemo_path.sample.rbをコピーして、引数で指定されたフォルダ名を書き込む

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
