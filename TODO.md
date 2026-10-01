## TODO・IDEA
### TODO
1. yaml形式のfrontmatterでタグ付け
- タグ付けによって欲しい機能(WIP)
    1. memo tag, memo tagsのCLIインターフェイス案
        - [OK]: memo tags --list
            - タグ名だけを返す
        - memo tags --empty
            - タグの付いていないファイル名の一覧を返す
        - memo tags --tally
            - タグごとの出現頻度を返す

### その他
# テスト系
## 型検査・型のテスト・テスト拡張
- Rdocかyard、型検査の導入、coverageの取得

## expected, actual
- expected, actualを意味的に逆に使っている箇所があるかもしれない
    - 洗い出す

## 機能追加
- 各メモファイルのfront matterにcreated_at, updated_atを挿入する

- memo checkのようなCLIが欲しい
    - memo tags --empty => memo check tagsなど
    - memo check duplicate => ファイル名の重複の調査

- CLIの自動補完機能
    - bash, zshと連携させてコマンドの自動補完機能を付けてみたい

## タグ系
1. それぞれのタグによって、特定の機能が欲しい
    a. 例えばタグにCLIとついている場合は、それに紐付くCLIの一覧が見れたら嬉しい
2. タグ名のTypoを検出する機能
    a. Settingとsetting, settingsなどの表記ゆれを検出する機能
    b. タグの出現頻度が１程度のものについて、そのタグの命名規則や単語に間違いがないか
    c. タグの検索は大文字小文字を区別しないようにしたい

## 命名など
- Repository.search_allやfindなどのメソッドの名前を整理したい
- @seeds => @file_seedsとする
- load => file_loadとする
    - loadとdir_loadについて、統合できないだろうか

## 修正するところ
- memo list, memo tagsにて、ディレクトリ・タグとファイル名の次に改行を入れたい
- その他、git grep TODOで出てくるTODOを解消していく
- sub_command_parserについて、memo tags --listを実行すると、memo listが実行されてしまう問題をもっと簡単なロジックで解決できるようにする

### gemspecをどうするか
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### CLIの拡張
1. fzfと連携させればファジーにメモを読むことができる
2. fzfを通すとフォルダの色付けが取れてしまう
3. Rainbowのconfigで修正できるかもしれない

#### 調査内容の詳細
- ** `memo list <dirs> | fzf | xargs -I{} memo read {}`で選択したメモを読むことができる
    - 例: `memo list cli | fzf | xargs -I{} memo read {}`
    - ** `memo list | fzf | xargs -I{} memo read {}`でも可能
        - `memo list`について、pipeやファイルに出力するとカラーコードが落ちてしまう
        - `memo list | xargs -I@ echo @`などで再現する
            - `Rainbow.enabled`の設定変更が必要？ -> パス名・環境変数系へ
