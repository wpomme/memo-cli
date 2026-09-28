## TODO・IDEA
### TODO
1. yaml形式のfrontmatterでタグ付け
- タグ付けによって欲しい機能(WIP)
    1. memo tag, memo tagsのCLIインターフェイス案
        - memo tag <TAG_NAME>
            - そのタグ名があれば、まず、そのタグが付いているファイルの数を表示し、次に、そのタグが紐付いてるファイル名を返す
            - そのタグがなければ、ない旨のメッセージを表示する
        - [OK]: memo tags
        - memo tags --list
            - タグ名だけを返す
        - memo tags --empty
            - タグの付いていないファイル名の一覧を返す
        - memo tags --tally
            - タグごとの出現頻度を返す
    2. それぞれのタグによって、特定の機能が欲しい
        a. 例えばタグにCLIとついている場合は、それに紐付くCLIの一覧が見れたら嬉しい
    3. タグ名のTypoを検出する機能
        a. Settingとsetting, settingsなどの表記ゆれを検出する機能
        b. タグの出現頻度が１程度のものについて、そのタグの命名規則や単語に間違いがないか

### その他
# テスト系
## 型検査・型のテスト・テスト拡張
- Rdocかyard、型検査の導入、coverageの取得

## expected, actual
- expected, actualを意味的に逆に使っている箇所があるかもしれない
    - 洗い出す

## 機能追加
- 各メモファイルのfront matterにcreated_at, updated_atを挿入する

## 修正するところ
- memo listにて、次のように表示したい
```bash
cli[緑色]
  folder1[緑色]
  file1[デフォルト色]
```
- select_promptにて`input = gets.chomp.to_i`がコマンドの引数を読んでいるよな動作をしており、エラーが出てしまうので修正する

### gemspecをどうするか
    - gemとして公開する必要がない。gemspecについて調査しておくこと

### CLIの拡張
1. fzfと連携させればファジーにメモを読むことができる
2. fzfを通すとフォルダの色付けが取れてしまう
3. Rainbowのconfigで修正できるかもしれない

### sub_command_parser
1. parsedを返す場合と、ヘルプ・ユーザーメッセージを返す場合を明確にする
2. to_error_message => to_user_messageにしてhelp_messageと共用化してもいい

#### 調査内容の詳細
- ** `memo list <dirs> | fzf | xargs -I{} memo read {}`で選択したメモを読むことができる
    - 例: `memo list cli | fzf | xargs -I{} memo read {}`
    - ** `memo list | fzf | xargs -I{} memo read {}`でも可能
        - `memo list`について、pipeやファイルに出力するとカラーコードが落ちてしまう
        - `memo list | xargs -I@ echo @`などで再現する
            - `Rainbow.enabled`の設定変更が必要？ -> パス名・環境変数系へ

#### CLIの自動補完機能
