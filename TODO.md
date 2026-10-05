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
2. タグ名のTypoを検出する機能
    a. Settingとsetting, settingsなどの表記ゆれを検出する機能
        - 簡易的なものなら、次のコマンドでOK
        - `memo tags -l | tr "[A-Z]" "[a-z]" | sort | uniq -c`

    b. タグの出現頻度が１程度のものについて、そのタグの命名規則や単語に間違いがないか
        - 簡易的なものなら、次のコマンドでOK
            - tags -tのUIについて、:でなく、タブか空白区切りにしたい
        - `memo tags -t | awk '$1 ~ /^1:/ { print $2 }'`

## 命名など
- Repository.search_allやfindなどのメソッドの名前を整理したい

## 修正箇所
- memo list, memo tagsにて、ディレクトリ・タグとファイル名の次に改行を入れたい
- その他、git grep TODOで出てくるTODOを解消していく
- なるべく、コメントに具体的な変数名などを書かないようにしたい
    - 実装の修正があった場合、そのコメントも修正する必要があるため
- メソッドの可視性の調査 => 変更、オブジェクトについて、必要なものはfreezeする
- CommandとViewを統合してもいいかもしれない。テストコードがほぼ同じことをしている
    - ファイル生成時間などの書き込みが機能として追加されたらreadとwriteは分けたい

### sub_command_parser
- sub_command_parserについて、memo tags --listを実行すると、memo listが実行されてしまう問題をもっと簡単なロジックで解決できるようにする
    - memo tags list => {tags: nil, list: nil}が返ってくる
        - これを生かした方が良さそうな気がする
        - --name, --count, --emptyはサブコマンドにする必要がないかもしれない
        - self.parse!の処理を一つ一つの引数ごとに処理するともしかしたら見通しが良くなるかも？
            - self.parse!(argv, count)のイメージ？
    - optionを読み取るとき、ハイフンなしの文字列を読み取るようにしたロジックがあるので、そこを考慮してコマンドのUIを改修する
- SubCommandSpecを作成するためのsub_command_factoryのようなクラスかメソッドが必要かもしれない
- `memo tags -h`でmemo tagsのヘルプが見れるようにしたい

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
