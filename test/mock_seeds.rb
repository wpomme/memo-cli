# frozen_string_literal: true

module Memo
  module MockSeed
    TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT = <<~ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE
      - ANSI escape code and set color to terminal
          - `RED='\033[31m'`のそれぞれの文字列の意味について
      1. '\033['
          - '\033'は制御文字の一種で、Escapeという名前である。
              - '\n'や'\t'の仲間
          - 表にすると次の通り
              - Octal: 八進数、Hexadecimal: 16進数, Decimal: 10進数
      | Key | Name |
      | ---- | ---- |
      | ^ | ^[ |
      | Octal | \033 |
      | Unicode | \u001b |
      | Hexadecimal | \x1B |
      | Decimal | 27 |
      | Abbr | ESC |

          - ESC に [ を組み合わせるとControl Sequence Introducer (CSI) と呼ばれる制御文字になる
          -> '\033[' -> 'ESC + [' -> CSI

      2. '31' <- 'CSI n m'
          - `CSI n m`という制御シーケンスは、Select Graphic Relation (SGR)と呼ばれる。
          - `n`はセミコロンで繋げることで、複数の値を選択できる

      2.1 SGRのパラメーター
      | 数字 | 名前 |
      | ---- | ---- |
      | 0 | リセット |
      | 1 | 太字 |
      | 3 | イタリック |
      | 4 | アンダーライン |
      | 7 | 文字色と背景色の反転 |
      | 30-37 | 文字色の指定 |
      | 38 | 文字色の拡張 |
      | 39 | 元の文字色にする |
      | 40-47 | 背景色の指定 |
      | 48 | 背景色の拡張 |
      | 49 | 元の背景色にする |

      * 38, 48の後には`5;n`か`2;r;g;b`が来る

      -> 31は文字色の赤を表す

      3. 'm' <- 'CSI n m'という制御シーケンスのうち、mが終端を表す

      4. まとめ
          - 例えば、文字色を緑にしたかったら'\033[32m'と'\033[0m'で挟むと、その間の文字色が緑になる
    ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE

    TEST_ALIAS_FILE_CONTENT = <<~ALIAS_FILE
      ## alias: CLIにエイリアスを付ける
      ```bash
      ## aliasを実行すると、その環境のエイリアスの一覧が見れる
      alias
      ```
    ALIAS_FILE

    TEST_BUILTIN_FILE_CONTENT = <<~BUILTIN_FILE
      ## builtin: そのコマンドがbuiltinかどうかを判別する
      - 組み込みだと正常終了し、何も帰ってこない
      - それ以外だと何かが帰ってくる
      - cdがカスタマイズされてないかどうかを調べたりするのに使うらしい
    BUILTIN_FILE

    TEST_HASH_FILE_CONTENT = <<~HASH_FILE
      ## hash: bash builtinコマンド
      ```bash
      ## hashを実行すると、その環境で実行できるコマンドと、そのパスの一覧が見れる
      hash | wc -l
      > 2692
      ```
    HASH_FILE

    TEST_LS_FILE_CONTENT = <<~LS_FILE
      ## ls: list directory contents
      ```bash
      ## 再帰的にファイル名を表示する
      ls -R memo/

      ## memo/フォルダの全てのファイルの詳細を表示する
      ## totalや空行は他のコマンドと組み合わせて消すのが一番良さそう
      ls -Rl memo/

      ## -Tは-lと組み合わせると年数も表示できる
      ls -RlT memo/

      ## さらに-tと組み合わせて、最終更新日時(mtime)が新しい順に表示することができる
      ls -RTlt memo/

      ## なお、-uも付けると、最終アクセス日時(atime)が新しい順に表示することができる
      ### 最終更新時間 -> Last Modified Time, 最終アクセス時間 -> Last Access Time
      ls -RTltu memo/

      ## aliasで定義されているlsの情報を確認
      ## -G: 色付け -F: ファイルの種別によって末尾に色々つける -p: ディレクトリの末尾にスラッシュを付ける
      ## * OSによってオプションの意味が結構変わるコマンドだったような...
      command -v
      > alias ls='ls -GpF'

      ## aliasで定義されているllの情報も確認
      ## -a: ドットファイルも表示する -l: 詳細表示（下記参照）
      command -v ll
      > alias ll='ls -alGpF'

      ## よく使うコマンド
      ### 更新順に表示するとき
      ls -lt

      ### 容量順に表示するときは-Sオプションを使う
      ### さらに、-hで容量に単位がつく
      ### なお、-sオプションは、使用しているブロック数を表示する
      ls -lS
      ```

      ## -lオプションについて

      - `-l`: 詳細表示
         以下のデータを表示する
         file mode, number of links, owner name, group name,
         number of bytes in the file, abbreviated month, day-of-month file was last modified, hour file last modified, minute file last modified,
         and the pathname.
    LS_FILE

    TEST_GROUPS_FILE_CONTENT = <<~GROUPS_FILE
      - groups: グループを表示する
          - idコマンドにより廃止された
          - `id -Gn [user]`と同等である
    GROUPS_FILE

    TEST_LSOF_FILE_CONTENT = <<~LSOF_FILE
      ## lsof: list open files - オープン中のファイルについて、その情報を得るためのコマンド

      ### 例: ポート8080によって開かれているファイルの情報を得るには
      ```bash
      lsof -i:8080
      # 次のような値が返ってくる
      # COMMAND   PID USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
      # node    25789   hy   32u  IPv6 0xc355a48837ad9ec6      0t0  TCP localhost:rwhois (LISTEN)
      ```

      ### 例: 特定のuserが開いているファイルの情報を得るには
      ```bash
      lsof -u <USER>

      ## USERが開いているプロセス名の一覧を取得するには
      lsof -u <USER> | cut -w -f1 | sort | uniq
      ```
    LSOF_FILE

    TEST_FIND_FILE_CONTENT = <<~FIND_FILE
      ## find: フォルダの階層を巡回する

      - 例
      ```bash
      # 名前に"foo"を含むファイルを検索する
      find . -type f -name "*foo*"

      # 実行可能なファイルを検索して、中身の文字数などを確認する
      find . -perm -a+x -type f -exec wc {} ;
      ```

      - オプション
          - `-print0`: 改行の代わりにヌル文字を使って入力文字列を区切る
    FIND_FILE

    TEST_CUT_FILE_CONTENT = <<~CUT_FILE
      ## cut: ファイルを適切なところでカットする

      - 例
      ```sh
      # psコマンドの最後の行(COMMAND)を除外する
      ps aux | cut -w -f1-10

      # スネークケースの最初の文字列だけ切り取る
      cut -d'-' -f2-
      ```

      - オプション
          - `-w` : デリミタとしてホワイトスペースを使う

    CUT_FILE

    TEST_ED_FILE_CONTENT = <<~ED_FILE
      ## ed: classic text editor

      ## 使い方１
      1. `ed <filename>`でファイルを読み込む
      2. コマンドを打ちながら修正したい行に移動したり修正する
      3. wでsave、qでedをexit、数字を打つとその行に移動して表示する、.を打つと現在の行を表示するなど

      ### 例(WIP)
      ```bash
      ## ファイルを読み込む
      ed foo.txt
      ```
    ED_FILE

    TEST_SED_FILE_CONTENT = <<~SED_FILE.freeze
      ## sed: stream editor

      ## 例
      ```bash
      # 1.1. gitリポジトリで対象のファイルの中の命名を置換したい場合
      ## 置換コマンドのところの-eを省略するとエラーが出る
      ## たぶんBSD版のsedを使っているMac限定のコマンド
      git grep -l 'foo' | xargs sed -i '' -e 's/foo/bar/g'

      # 1.2. ls を使ったファイルの中身の置換
      ls | xargs sed -i '' s/foo/bar/g

      # 2. ファイル名の一括リネーム
      # 2.1. lsと組み合わせる
      ls | sed "p;s/test/foo-test/" | xargs -n 2 mv


      ## その他、オプションの使い方など
      ### lsでフォルダを除外して、ファイル名だけを表示するには
      ```bash
      $ ls -p | grep -v /
      ```

      ## オプションの詳細
      - p: sedで変換される前の文字列も表示する
      - i: 拡張子を指定して上書き(BSD version) -> macのsedはBSD#{'  '}
          -> 空の文字列を指定すればバックアップなしの上書きになる#{'  '}
          上書き(GNU version)#{'  '}

    SED_FILE

    TEST_UNIQ_FILE_CONTENT = <<~UNIQ_FILE
      - uniq: 文字の重複排除
          - 他のコマンドとsortと組み合わせて使うことが多い
      ```bash
      # 例: コマンド履歴の集計
      fc -ln 1 | sort | uniq -c | sort
      ```
    UNIQ_FILE

    TEST_XARGS_FILE_CONTENT = <<~XARGS_FILE.freeze
      ## 例
      - -Iコマンド
      ### コマンドに渡す引数の場所を指定する
      ```bash
      echo 01 Black Rain.aiff | tr " " - | xargs -I{} mv 01 Black Rain.aiff {}
      ```

      - -nコマンド
      ### コマンドに渡す引数の数を制御する
      - できるだけ多くの入力文字列を受け入れる
      ```bash
      ls | xargs echo
      ```

      - 一つのechoコマンドにつき一つの引数を渡す
      ```bash
      ls | xargs -n1 echo
      ```

      - findとの組み合わせ
      拡張子のあるファイルパスを取得して、行数を数える#{'  '}
      findに-print0を指定して、改行の代わりにヌル文字でファイルパスのリストを区切る#{'  '}
      また、xargsに-0を指定して、空白の代わりにヌル文字を入力セパレーターとして認識する#{'  '}
      ```bash
      $ find . -type f -name "*.*" -print0 | xargs -0 wc -l
      ```
    XARGS_FILE

    TEST_SSH_FILE_CONTENT = <<~SSH_FILE
      ```bash
      ssh <login name>@<address>
      ```
    SSH_FILE

    TEST_CLAUDE_FILE_CONTENT = <<~CLAUDE_FILE
      # claude CLI
      - `/resume`
      過去のセッションを選択して再開する
    CLAUDE_FILE

    TEST_GH_FILE_CONTENT = <<~GH_FILE
      ## gh: github CLI
      ```bash
      # 現在のブランチのPR のステータスを確認する場合
      ## マージ済みかどうかなどが分かる
      gh pr status

      # より詳細な情報 (タイトル、本文、レビュー状態など)
      gh pr view

      # CI チェックの結果一覧
      # URL からCI のRun ID が分かる
      gh pr checks

      # CI を再実行する
      gh run rerun <run-id>
      ## 詳細に指定する場合
      gh run rerun <run-id>  --repo <repo-name> --failed
      ```
    GH_FILE

    TEST_MISE_FILE_CONTENT_1 = <<~MISE_FILE
      # mise.md
      # TODO: mise の設定に関することは docs/setting/mise.md に書く
      ## mise
      - nodejsやpythonなど、ランタイムのバージョンを管理できるツール
          - 他にも使い出がありそう

      ### 例
      ```bash
      # サブコマンドの一覧を表示
      mise

      # サブコマンドのヘルプを表示
      mise help <subcommand>

      # パッケージをインストールしてmise.toml. にパッケージを追加するコマンド
      # mise で利用できるパッケージの一覧が見れる
      mise use

      # 利用できるRubyのランタイムを全て表示
      mise ls-remote ruby

      # 利用できるRubyのランタイムのうち、バージョンが4系のものを表示する
      mise ls-remote ruby@4
      ```

      - miseのconfigファイルを管理する
      ```bash
      # miseのコンフィグファイルの一覧を見る
      mise config
      ```

      - 管理しているランタイムやパッケージの詳細情報を確認
      ```
      mise ls
      ```

      - nodejsの最新のLTSをインストールする
      ```
      mise use -g node@lts

      # mise で管理できるプラグインの一覧をみる
      mise registry
      ```
    MISE_FILE

    TEST_NKF_FILE_CONTENT = <<~NKF_FILE
      - nkf: 文字コードの判定・変換
      ```bash
      # 文字コードを推測する
      nkf --guess <filename>

      # 例 ls のドキュメントの文字コード
      nkf --guess <(man ls)
      UTF-8 (LF)

      # ISO-2022-JP (JIS code) 形式のテキストを表示する
      nkf -J <filename>
      ```
    NKF_FILE

    TEST_UNITS_FILE_CONTENT = <<~UNITS_FILE
      - units: 単位の計算ができる
          - mac版だと'/usr/share/misc/units.lib'に使える単位の一覧がある
    UNITS_FILE

    TEST_APPLY_FILE_CONTENT = <<~APPLY_FILE
      - パッチファイルを適用する
      ```bash
      git apply <filename>

      # 例
      git apply patch.diff
      ```

      - patchコマンドでも差分を取り込めるらしい
    APPLY_FILE

    TEST_CHECKOUT_FILE_CONTENT = <<~CHECKOUT_FILE
      ## `git checkout`から`git switch`, `git restore`へ
      - `git checkout`の役割
          - ブランチの切り替え
          - 新規ブランチの作成
          - ファイルの復元
          - コミットのチェックアウト

          -> これらを`git switch`か`git restore`へ
    CHECKOUT_FILE

    TEST_CONFIG_FILE_CONTENT = <<~CONFIG_FILE
      - gitのアカウント情報などの確認
      ```bash
      git config -l
      ```

      - ローカルのgitアカウント作成
      ```bash
      git config --local user.name "<username>"
      git config --local user.email "<email>"
      ```

      ```bash
      # テキストエディタをneovimにする
      git config --global core.editor 'nvim'

      # テキストエディタをVimにする
      git config --global core.editor 'vim -c "set fenc=utf-8"'
      ```
    CONFIG_FILE

    TEST_DIFF_FILE_CONTENT = <<~DIFF_FILE
      ## git diff: 差分を取る
      - 例
      ```bash
      # stagedしたファイルのdiff
      git diff --cached

      # ファイル名だけ取得
      git diff --name-only

      # git diff を標準出力に書き出す
      git --no-pager diff

      # なお、`--no-pager`は`git`コマンド全体で使える。
      git --no-pager <subcommand> <options>

      # 直前のコミットとdiffをとる
      # patchファイルを作成するときなどに使う
      git diff HEAD^ HEAD

      # patchファイルを作成
      git diff HEAD^ HEAD > patch.diff
      ```
    DIFF_FILE

    TEST_GITIGNORE_FILE_CONTENT = <<~GITIGNORE_FILE
      - .gitignore
      ## ローカル環境だけでgitignoreを設定するには
      .git/info/excludeに該当のファイル・フォルダ名を書けばいい
    GITIGNORE_FILE

    TEST_MERGE_FILE_CONTENT = <<~MERGE_FILE
      - git squash
      ```bash
      # git squashしてマージ
      git merge --squash origin/feature/foo

      # コンフリクトの事前確認
      git merge --no-commit --no-ff feature/foo
      ```
    MERGE_FILE

    TEST_PUSH_FILE_CONTENT = <<~PUSH_FILE
      - 現在チェックアウトしているブランチをpushする
      ```bash
      # 最もシンプルな方法
      git push origin HEAD
      # 上流ブランチ(upstream)が設定済みならgit push でOK
      git push
      # 最初に-uを付けて上流を設定しておけばいい
      git push -u origin HEAD
      ```

      ## 上流ブランチ(Upstream Branch)
      - ローカルブランチが追跡(トラッキング)しているリモートブランチのこと
      ```bash
      ## 上流ブランチの設定方法
      # -u(--set-upstream)オプションを追加する
      git push -u origin <branch-name>

      ## 現在のブランチが上流ブランチに設定されているかどうかを確認
      git rev-parse --abbrev-ref @{upstream}
      # -> 未設定の場合はエラーになる
      ```

    PUSH_FILE

    TEST_RESET_FILE_CONTENT = <<~RESET_FILE
      - resetとrevertの違い
          - reset -> コミットログが残らない
          - revert -> コミットログが残る

      - featureブランチで直前のコミットを取り消す
      ```bash
      git reset --soft HEAD^
      ```
    RESET_FILE

    TEST_REV_PARSE_FILE_CONTENT = <<~REV_PARSE_FILE
      - rev-parse
          - "Pick out and massage parameters"というporcelain command

      - `git rev-parse --show-toplevel`
          - 対象のgitリポジトリの第一階層のディレクトリを取得できるコマンド
          - このコマンドをスクリプトで使用する際の注意点
          1. gitリポジトリ外で実行するとエラーになる
          2. worktree内での実行、シンボリックリンク経由による実行、サブモジュール内での実行

          - 改善版
      ```bash
      # Add Error Handling
      REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
        echo "Error: not inside a git repository" >&2
        exit 1
      }

      TARGET_PATH="$REPO_ROOT/path/to/target"
      ```

      - なお、gitに依存したくない場合はこちら
      ```bash
      SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
      REPO_ROOT="$(cd "$SCRIPT_DIR/path/to/target" && pwd)"
      ```
    REV_PARSE_FILE

    TEST_UPSTREAM_FILE_CONTENT = <<~UPSTREAM_FILE
      ## upstream: 追跡ブランチ

      ```bash
      ## git pushするときに-u(--set-upstream) originを付けると、そのブランチは追跡ブランチとなる
      git push -u origin feature/foobar
      # -> 次回以降はgit pushだけでpushできる

      ## 追跡ブランチが設定されているかどうかを確認するには
      git branch -vv
      # -> 三番目の項目に[origin/feature/foobar]などと表示されていれば、そのブランチは追跡ブランチ
      ## コマンドで抽出するなら:
      git branch -vv | grep '[origin/'

      ## 追跡ブランチを取り消すには
      git branch --unset-upstream develop

      ## ただし、git pullするときにorigin developを追加する必要がある
      git pull origin develop
      ```
    UPSTREAM_FILE

    TEST_DATA_EXCHANGER_FILE_CONTENT = <<~DATA_EXCHANGER_FILE
      ## 概要
      - パソコン間でファイルの送受信をしたいときなど

      ### 送り手側
      1. ncで送信する
      ``` sh
      # -l でリスナーモードにする
      # ポート番号は任意のものを使用する。一旦8888とする。
      cat file.txt | nc -l 8888

      # 画像などは多分こっちがいい
      nc -l 8888 < file.jpeg
      ```

      2. 送信側IPアドレスを調べる
      ``` sh
      ifconfig | grep "inet "
      ```

      ### 受け手側
      1. ncで受信する
      ``` sh
      nc [送り手川のIPアドレス] 8888 > received.txt
      ```
    DATA_EXCHANGER_FILE

    TEST_SERVER_FILE_CONTENT = <<~SERVER_FILE
      - server: 簡易的なWebサーバーを起動させる方法
      ```bash
      # ruby
      ruby -rwebrick -e 'WEBrick::HTTPServer.new({:DocumentRoot => "./"}).start'

      # python
      python3 -m http.server 8000
      ```
    SERVER_FILE

    TEST_HOVER_FILE_CONTENT = <<~HOVER_FILE
      ## hover: CSSの擬似クラス
      - カーソルを要素の上にかざしたときに発動するスタイル

      ### 順番
      - LVHA順で定義されるようにする
          - :link — :visited — :hover — :active

      ## 例
          - 擬似クラスを複数記載する場合はカンマで区切る
      ```css
      .link-button:hover, :active {
          background-color: blue;
      }
      ```
    HOVER_FILE

    TEST_CONSOLE_FILE_CONTENT = <<~CONSOLE_FILE
      - console
      ```javascript
      # Map オブジェクトにはconsole.table()を使うと中身が見やすい
      const map = new Map(obj);
      console.table(map);

      # Object にはconsole.dir() がいい
      # Map に使うと全部見えてしまう
      console.dir(obj);
      ```
    CONSOLE_FILE

    TEST_MAP_FILE_CONTENT = <<~MAP_FILE.freeze
      - map
      ```javascript
      # 値を得るときはget() を使う
      const map = new Map();

      map.get("key")
      // -> key に対応するvalue が返ってくる
      ```

      ## JSDoc の書き方
      ```javascript
      /**
       *#{' '}
       * @param {Map<string, String>} userMap - ユーザーとユーザーに紐づくMap
       */
      ```
    MAP_FILE

    TEST_PACKAGE_JSON_FILE_CONTENT = <<~PACKAGE_JSON_FILE.freeze
      ## package.json:#{' '}

      ### バージョン指定について
      - 数字のみ: 指定したバージョンと正確に一致するバージョンがインストールされる

      - キャレット(^): メジャーバージョン以外の更新は可能とする
          - ^1.2.3: 1.2.3以上、2.0.0未満までのバージョン更新を可能とする

      - チルダ(~): マイナーバージョンの更新を可能とする
          - ~1.2.3: 1.2.3以上、1.3.0未満までのバージョン更新を可能とする

      - 大なり(>): 指定したバージョン以上なら更新可能とする

    PACKAGE_JSON_FILE

    TEST_LUA_FILE_CONTENT = <<~LUA_FILE
      ## lua

      ### パッケージマネージャー
      - `luarocks`を使う
          - homebrewからインストールする

      ### リンター
      - `luacheck`を使う
          - luarocksからインストールする
              - ref: https://github.com/lunarmodules/luacheck#installation

      - neovimの設定ファイルにLinterを実行
          - dotfiles/の下に`.luacheckrc`を作成する
              - globalsに`vim`を設定し、accessing undefined variable vimの警告をなくす

      #### 実行
      ```bash
      luacheck config/nvim/**/*.lua
      ```
    LUA_FILE

    TEST_ONELINER_FILE_CONTENT = <<~ONELINER_FILE
      ## Perl one-liners: Perlによるワンライナー
      ```bash
      ## ドキュメント: perlrunにperlコマンドのオプションの解説がある
      man perlrun

      ## grep系
      ### ドットファイルだけを取得
      ls -alGpF | perl -lane 'print if $F[-1] =~ /^./'

      ### bashのマニュアルから章を抜き出すコマンド
      man bash | perl -ne 'print if /^[A-Z]/'

      ### 特定のフォルダから、"href="か"src="が含まれている行を抜き出すコマンド(正規表現の「選択」)
      find packages/web/src | xargs -I@ perl -ne 'print if /href=|src=/' @

      ###
      find lib/ test/ -type f | xargs -I@ perl -ne 'print if /\Qseed[:filename]\E|\Qseed.filename/' @
      find lib/ test/ -type f | xargs -I@ perl -n -e 'print if /seed[:dir]/ or /seed.dir/' @
      find lib/ test/ -type f | xargs -I@ perl -pi -e 's/seed[:dir]/seed[:parent_dir]/g' @
      ## sed系
      ### 対象ファイルについて、文字列の一括置換を行う場合(in-place編集)
      git grep -l NOT_FOUND_MESSAGE | xargs -I@ perl -pi -e 's/NOT_FOUND_MESSAGE/READ_RESULT_IS_NOT_FOUND/g' @

      ### マッチする部分が正規表現ではなくて文字列である場合は、正規表現の最初に\Qを付ける
      ### 置換する文字列にも\Qを付けてしまうと、メタ文字も一緒に置換されてしまう
      echo "_(expected).must_equal(actual)" | perl -p -e 's/\Q_(expected).must_equal(actual)/_(actual).must_equal(expected)/g'

      ### マッチングしたものを取り出す場合: https://perldoc.jp/docs/perl/5.22.1/perlretut.pod#Extracting32matches
      ### グループ化メタ文字()の中でマッチしたものは、$1, $2, ...などで取り出せる
      ### must_equalのカッコの中身にマッチさせて、その中身を_()の中に移動する
      echo "_(expected).must_equal([:list, 'foo'])" | perl -p -e 's/\Q_(expected).must_equal(\E(.+))/_($1).must_equal(expected)/g'
      # => _([:list, 'foo']).must_equal(expected)
      ```

      ## オプション
          - `man perlrun`にオプションのドキュメントがある。詳しくはそちらを参照すること。
      - -e: perlのワンライナーを入力するために使用する。-eの後にワンライナーを入力すれば、perlはそのワンライナーを認識する
      - -n: 一行ずつ処理する。ダイアモンド演算子と`while (<>) {...}`と同じ。`sed -n`や`awk`と似たような処理を実行する
      - -p: -nと同じように一行ずつ処理するが、警告が-nより詳しい。perlにprintさせるだけなら、-nを使う。
      - -i: in-placeで編集する。-iの後に何も指定しなければ、同じファイルを編集する。バックアップが不要なら`perl -i -e '...' <filename>`のようにして使う。
      - -l: 行末処理の自動化を行う。入力時に改行を削除し、出力時に改行を追加する。

      ## 正規表現のオプション
      - \Q: その正規表現のメタ文字をエスケープする
      - \E: \Qなどのエスケープを\Eが追加された位置で終了させる
    ONELINER_FILE

    TEST_BUNDLE_FILE_CONTENT = <<~BUNDLE_FILE
      - bundle
          - プロジェクトごとに使うRubyのパッケージマネージャー

      - How to use
      ```bash
      # Gemfileを作成する
      bundle init

      # パッケージのminitestを追加する
      bundle add minitest

      # そのプロジェクトの全てのgemを確認する
      bundle show

      # そのプロジェクトのパッケージを読み込んだ状態でirbにログインする
      bundle exec irb
      ```

      - rakeとbundle exec rake
          - `rake` -> システムにインストールされた`rake`を使う
          - `bundle exec rake` -> Gemfile.lockで固定されたバージョンの方の`rake`を使う

      - bundle gem
      ```bash
      # rubygem を作るための雛形を作成するコマンド
      # <name> -> . とすればカレントディレクトリが指定される
      # Gemfile や README が既にあると、上書きしていいかどうか聞かれる
      bundle gem <name>
      ```

      - bundler/gem_tasks
      ```ruby
      # Rakefileでbundler/gem_tasksをインポートすると、build, release, installなどが行える
      require "bundler/gem_tasks"
      ```
    BUNDLE_FILE

    TEST_COMPARE_FILE_CONTENT = <<~COMPARE_FILE
      ## Rubyオブジェクトの比較の仕方
      - 趣旨: 言語やそのオブジェクトによって値の比較方法が特殊だったりするので
          - JavaScriptの===や!= nullとか...言語によるので
          - Rubyの中で特筆すべき比較方法を書いておく場所

      - Setの比較
          - ==について
              1. どちらもSetオブジェクトであること
              2. 要素が同数であること
              3. 全ての要素が等しいこと
    COMPARE_FILE

    TEST_MINITEST_FILE_CONTENT = <<~MINITEST_FILE
      ## minitest: 軽量なテスティングフレームワーク

      - expectedとactualの位置
          - なぜか混同してしまうので
      ```rb
      ## spec形式
      ## この順番！
      _(expected).must_equal(actual)

      ## assertion形式
      assert_equal expected, actual
      ```
    MINITEST_FILE

    TEST_RAKE_FILE_CONTENT = <<~RAKE_FILE
      - rake: タスクランナー
      ```bash
      # タスクの一覧を表示する
      rake -T
      ```
    RAKE_FILE

    TEST_START_PROJECT_FILE_CONTENT = <<~START_PROJECT_FILE
      ## Start Project with Ruby: Rubyでプロジェクト・リポジトリを作成には

      ```bash
      # 1. bundlerでGemfileを作成する
      bundle init

      # 2.1. 作成されるGemfileに使いたいパッケージを追加する
      gem "rails", "~>8.1"

      # 2.1.1. bundle installすればOK
      bundle install

      # 2.2. bundle addでも良さそう
      bundle add minitest
      ```

      - * なお、`bundle gem`コマンドでRubyGemを作成することができる
    START_PROJECT_FILE

    TEST_TYPE_CHECK_FILE_CONTENT = <<~TYPE_CHECK_FILE
      ## Ruby型検査
      - テストコード
      ```ruby
      ## 配列の要素が全て同じなら真が戻り値になる
      ## Array#all?に検査したい型を入れる
      require "minitest/expectations"

      expected = seeds.all?(Memo::Model::Seed)

      _(expected).must_equal(true)
      # => true
      ```
    TYPE_CHECK_FILE

    TEST_TEST_ASSERTION_FILE_CONTENT = <<~TEST_ASSERTION_FILE
      ## テストアサーションについて
      - いつもexpectedとactualを逆に書いている気がする......。
      - 文献がいつもexpectedとactualが逆なような......

      ### 期待値と実際の値
      - expected(期待値): テストを実行する側が、こうあるべきとして定義する値
      - actual(実際の値): テストを実際に実行して得られる値

      ### Ruby
      minitestのassert, specは次の順番でactual, expectedを書く
      ```ruby
      ### assert
      assert_equal expected, actual

      ### expectation
      _(actual).must_equal(expected)
      ```
    TEST_ASSERTION_FILE

    TEST_MEMO_SUMMARY_FILE_CONTENT = <<~MEMO_SUMMARY_FILE
      ## summary: memorandumの集計情報
      ```bash
      ## 作成したファイルの数
      ## READMEなども含めた数
      find memo -type f | wc -l
      > 92

      ## 作成したファイルの総行数
      ## 最後のtotalに表示される
      find memo -type f | xargs wc -l
      > 1597 total

      ## lsやgrepでも集計情報が取得できそう
      ```

    MEMO_SUMMARY_FILE

    TEST_COMMAND_FILE_CONTENT = <<~COMMAND_FILE
      ## Command Line Mode: neovimのコマンドラインモード

      ## コマンドの詳細を調べたい場合
      ```
      # コマンドラインモードでkeymapの詳細を調べる
      :verbose command <Command>
      # 例
      :verbose command Git
      ```
    COMMAND_FILE

    TEST_KEYMAP_FILE_CONTENT = <<~KEYMAP_FILE
      ## keymap

      ## noremap, silentの意味
      - noremap
          - 他のショートカットキーの設定に連鎖させないようにする
      - silent
          - キーの実行時に、画面下のコマンドラインに実行コマンドやメッセージを表示させない

      # 例
      ```
      -- 次のバッファへ移動 (Tab)
      vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
      -- 前のバッファへ移動 (Shift+Tab)
      vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })
      ```

      ## keymapの重複を調査する
      ```
      # checkhealthを実行すろと、which-keyプラグインの方でkeymapの重複を調べてくれる
      :checkhealth

      # コマンドラインモードでkeymapの詳細を調べる
      :verbose map <your-keybinding>
      # 例
      :verbose map <C-b>
      :verbose nmap <leader>f
      ```
    KEYMAP_FILE

    TEST_NETRW_FILE_CONTENT = <<~NETRW_FILE
      ## netrw: 組み込みファイラ
      - 起動
      ```
      :Ex
      ```

      - 表示モード切り替え
      <kbd>i</kbd>
          - thin -> long -> wide -> tree
          - * このdotfilesではデフォルトの表示モードをtreeにしてある

      - 新しいタブで開く
      <kbd>t</kbd>

    NETRW_FILE

    TEST_VIM_PACK_FILE_CONTENT = <<~VIM_PACK_FILE
      ## vim.pack
      - neovim組み込みのプラグインマネージャー
      - ドキュメント
      :h vim.pack | only
    VIM_PACK_FILE

    TEST_READ_ONLY_FILE_CONTENT = <<~READ_ONLY_FILE
      ## 閲覧モードなど
      - 編集不許可の`-M`オプションを付けると便利。neovimでも同様。余計なキーを押したときに編集が不可能になる。
      ```
      nvim -M error.log
      ```

      - 読み取り専用にする場合は`-R`オプションを付けるなど。
      ```
      vim -R error.log
      ```
    READ_ONLY_FILE

    TEST_TEXT_OBJECTS_FILE_CONTENT = <<~TEXT_OBJECTS_FILE
      ## text objects: テキスト操作のためのコマンド

      ### 例
      - 単語を一つだけヤンクするには:
          `yiw` or `yaw`
          y: yank operator
          iw, aw: text objects

      - 引用符で囲まれた範囲をヤンクするには:
          `yi"` or `ya"`

      - 検索した単語を置き換えるには:
          `cgn`
          => `n`と`.`を組み合わせて検索した単語を順次置き換えられる


      ### オペレーター
      - d: 削除
      - y: ヤンク
      - c: 変更
      - v: 選択

      ### 範囲指定
      - i: inner - 内側
      - a: a/around - 外側

      ### オブジェクト
      - w: word - 一単語
      - s: sentence - 一行の場合が多い
      - 引用符、カッコ: 該当の引用符、カッコを指定する
      - b: block - ブロックという単位を表す。Rubyのブロックと対応していた。
      - gn: 最後に使われた検索パターンを前方検索しマッチしたものを選択してビジュアルモードを開始する
          - n: 検索した単語について前方に移動
          - N: 検索した単語について後方に移動
          - ref: https://vim-jp.org/vimdoc-ja/visual.html#gn

    TEXT_OBJECTS_FILE

    TEST_VIRTUAL_TEXT_FILE_CONTENT = <<~VIRTUAL_TEXT_FILE
      ## Virtual Text: 仮想のテキスト表示

      ### yankする方法
      ```
        方法1: :luaでdiagnosticメッセージを取得してレジスタに入れる
        :lua vim.fn.setreg('+', vim.diagnostic.get(0)[1].message)

        カーソル行のdiagnosticを取得する場合：
        :lua local d = vim.diagnostic.get(0, {lnum = vim.fn.line('.')-1}); vim.fn.setreg('+', d[1].message)

        方法2: Floating windowを開いてそこからyank
        :lua vim.diagnostic.open_float()

        方法3: :messages 経由（一時的に表示させる場合）
        1. :lua print(vim.diagnostic.get(0, {lnum = vim.fn.line('.')-1})[1].message)
        2. :messages で履歴を確認してコピー
      ```
    VIRTUAL_TEXT_FILE

    TEST_DOCKER_COMPOSE_FILE_CONTENT = <<~DOCKER_COMPOSE_FILE
      - docker-compose.yml
      ## 書式
      ```
      ## 左側がホスト側、右側がコンテナ側
      ## ホスト側のディレクトリ・ファイルをコンテナ側にマウントする
          volumes:
            - ./html:/usr/share/nginx/html
      ```
    DOCKER_COMPOSE_FILE

    TEST_EDITORCONFIG_FILE_CONTENT = <<~EDITORCONFIG_FILE
      - editorconfig
          - リポジトリのトップに.editorconfigを作成しておけばファイルのフォーマットが簡単にできる
          - サイトURL: https://editorconfig.org/
          - VimとNeovimは標準でサポートされている
    EDITORCONFIG_FILE

    TEST_MISE_FILE_CONTENT_2 = <<~MISE_FILE
      # mise.md
      ## mise.toml
      - mise.tomlを読み取る順番(抜粋)
          - ~
          - .config/mise.toml        (local)
          - .cinfig/mise/config.toml (dotfiles)
          - ~

      - install
      ```bash
      # mise install でそれぞれのmise.toml をみてパッケージをインストールする
      mise install
      ```
    MISE_FILE

    TEST_BASH_FILE_CONTENT = <<~BASH_FILE.freeze
      ## bash: GNU Bourne-Again SHell

      ## ドキュメントについて
      - manページを確認することが基本: `man bash`
      - 特に重要な章を次にリストアップしておく
      ```plain
      # bashの組み込みコマンドに関する説明が載っている
      # echo, cd, alias, type, command, etc...
      SHELL BUILTIN COMMANDS

      # コマンドや変数の展開について
      EXPANSION
      ```

      ## bashの章を抜き出すコマンド
      ```bash
      man bash | perl -ne 'print if /^[A-Z]/'
      ```

      ## Tips
      Control + l(C-l)で画面にある出力を消去できる#{'  '}
      詳しくはman bashのCommands for Movingを参照#{'  '}
      その他、(M-f)と(M-b)で単語単位で前後に移動できる、など#{'  '}

      ### コマンドを例示するときのドル記号($)とハッシュ(#)の違い
      - $ -> 一般ユーザー
      - # -> rootユーザー

      ## 条件付きリスト(conditional list)
      ### &&演算子
      - cd dirが成功した場合にのみ、touch new.txtを実行
      ```bash
      $ cd dir && touch new.txt
      ```

      ## ||演算子
      - cd dirが失敗した場合、エラーコード1で終了する
      ```bash
      $ cd dir || exit 1

      # 例
      ## フォルダがなければ作成する
      [ -d path/to/folder ] || mkdir -p path/to/folder
      ```

      ## 複数の文字列を変数に入れるとき
      - `read`を使う。`while`やパイプと組み合わせる。
      ```bash
      echo 'aaa bbb ccc' | while read A B C
      do
        echo $A, $B, $C
      done
      # > aaa, bbb, ccc
      ```
    BASH_FILE

    TEST_EXIT_STATUS_FILE_CONTENT = <<~EXIT_STATUS_FILE
      - EXIT STATUS
          - CLIコマンドの終了ステータス

      man bash -> EXIT STATUSの章に載っている
      0 - 正常終了
      1 - 一般エラー
      2 - 誤用法(引数や文法エラー)

      厳密な規約はない

      ## 判定方法
      - $?を使うこと(shell-variables.mdと同じ内容)
          - $?: 直前に実行したコマンドの実行ステータス
      ```bash
      ## これで確認できる
      echo $?
      ```
    EXIT_STATUS_FILE

    TEST_FOR_FILE_CONTENT = <<~FOR_FILE
      ## bash - for 文
      - 動機: bashだとパイプラインとxargsだけだとfilterのようなものを作成するのが難しかった...
          - xargsの後にbash -c '<command>'とすれば出来そうだったけど

      ```bash
      ##
      ## man bashの中のSHELL GRAMMARという章のCompound Commandsという項に載っている
      ## 次で大体見つかるはず
      man bash
      /^SHELL GRAMMAR

      ## パターン１
      ## for name [ in word ] ; do list ; done
      ## nameがfor文の中で使える変数になる。[ in word ]は色々なパターンがあったと思うが、
      ## ここでは、コマンド置換としている。doの後のlistのところに処理を書いて、doneで終了
      ## 例:
      for DIRS in `find "$HOME/repo/memorandum/memo" -type f`; do
        echo $DIRS
      done
      ```
    FOR_FILE

    TEST_PARAMETER_EXPANSION_FILE_CONTENT = <<~PARAMETER_EXPANSION_FILE
      - Parameter Expansion
          - `$`がパラメーターの展開に使われる

    PARAMETER_EXPANSION_FILE

    TEST_SHEBANG_FILE_CONTENT = <<~SHEBANG_FILE
      # シェバン(shebang)
      ```
      # 例
      ## bash
      #!/usr/bin/env bash

      ## zsh
      #!/usr/bin/env zsh
      ```
    SHEBANG_FILE

    TEST_SPECIAL_PARAMETERS_FILE_CONTENT = <<~SPECIAL_PARAMETERS_FILE.freeze
      - Special parameters
      Special Parameterは$ を付けて展開する(Parameter Expansion)
          - #: スクリプトや関数に渡された引数の数
          - Ref: Expands to the number of positional parameters in decimal

          - ?: 直前に実行したコマンドの実行結果。0 ならTrue である。
          - Ref: Expands to the status of the most recently executed foreground pipeline.

          - !: 直前に実行したコマンドのプロセスID#{' '}
          - Ref: Expands to the process ID of the most recently executed background (asynchronous) command.
    SPECIAL_PARAMETERS_FILE

    TEST_COMMAND_HISTORY_FILE_CONTENT = <<~COMMAND_HISTORY_FILE
      - Zshのコマンド履歴
          - fcコマンドを使う
          - コマンド履歴はtmuxだとウィンドウごとである
          - ドキュメントはman zshbuiltinsからfcで検索すること
      ```zsh
      # 直前のコマンド履歴を見る
      # fc -l

      # 数が指定できる
      # fc -l 500

      # 全ての履歴を番号なしで表示する
      fc -ln 1

      ## コマンド履歴の集計
      fc -ln 1 | sort | uniq -c | sort

      ## コマンドの文字列検索
      fc -lm "git*"
      ```
    COMMAND_HISTORY_FILE

    TEST_EMACS_FILE_CONTENT = <<~EMACS_FILE
      - Emacs: エディター
      ## TUI というよりIDE に近い気がする
      ## 今後使用することはないと思うが、一部のコマンドをvim で使用しているので、残しておく
      ## 例
      - 改行
      <kbd>C</kbd> + <kbd>o</kbd>
      - 先の行を消す
      <kbd>C</kbd> + <kbd>k</kbd>
      - 前の行を消す
      <kbd>C</kbd> + <kbd>u</kbd>
      - 単語を消す
      <kbd>C</kbd> + <kbd>w</kbd>
      - 一文字を消す
      <kbd>C</kbd> + <kbd>h</kbd>
    EMACS_FILE

    TEST_LAZYGIT_FILE_CONTENT = <<~LAZYGIT_FILE
      ## lazygit: git status, git addなどの操作を簡単にするTUI
      ### 基本
      - <space>: stagedとuntrackedをトグルする
      - e: 該当のファイルを編集する
      - q: lazygitを閉じる
      - ?: キーマッピングの一覧を見る
          - <esc>でキーマッピングの画面を閉じる

      - 画面下部の方に主要なキーマッピングが載っているので要確認
    LAZYGIT_FILE

    TEST_TMUX_FILE_CONTENT = <<~TMUX_FILE
      ## 例
      - 10番目以降のwindowに移動する
          - 番号を指定して移動する
          `prefix + '`
          - インタラクティブな移動
          `prefix + w`

      - セッション
          - セッションに名前を付けて起動する
              `tmux new -s <session-name>`
          - 指定したセッションを起動する
              `tmux attach -t <target-session>`
          - 次のセッションに移動する
              `prefix )`
          - 前のセッションに移動する
              `prefix (`

              * target-sessionは次の順番で決まる
              1. $ のついたsession ID
              2. セッションの正確な名前
              ...

          - セッションを一時終了する(Detach)
              - `prefix + d`
          - 直前のセッションに戻る(Attach)
              - `tmux a` or `tmux attach`
              1例: 間違ってDetachしたときは`tmux attach`で復元する
              2例: 複数のセッションを起動させるとき、最初のセッションをDetachして、ターミナルで新しいtmuxを起動させる
                  - その際は、tmuxに名前を付けると良さそう
                  - ほとんど不具合を起こさない開発サーバーにtmux1を割り当てて、それ以外をtmux2にするとか?


      - ウィンドウ
          - 全てのウィンドウの一覧を表示
          `tmux list-windows`

          - 現在開いているウィンドウを完全に終了する
          `Ctrl + d`
              - `prefix + d`としてしまうと、セッションがDetachとなるので注意すること

          - ウィンドウを番号指定で閉じる
          `tmux kill-window -t <session-name>:<window-number>`
              - 例: 現在のセッションの５番目のウィンドウを閉じる
              `tmux kill-window -t 5`

          - ウィンドウの名前を変更する
          `prefix + ,`

      - その他
          - tmuxのコマンド一覧
          `tmux list-commands`

      - tmuxのドキュメント
          - tmux attachのドキュメントを探す
          1. `man tmux`
          2. `/attach-session`

          - tmux newのドキュメントを探す
          1. `tmux list-commnads | grep new`
    TMUX_FILE

    TEST_MEMO_DATA_SEED = [
      {
        parent_dir: "memo",
        basename: "ANSI-escape-code-and-set-color",
        content: TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/builtin",
        basename: "alias",
        content: TEST_ALIAS_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/builtin",
        basename: "builtin",
        content: TEST_BUILTIN_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/builtin",
        basename: "hash",
        content: TEST_HASH_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/file",
        basename: "ls",
        content: TEST_LS_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/old",
        basename: "groups",
        content: TEST_GROUPS_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/process",
        basename: "lsof",
        content: TEST_LSOF_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/search",
        basename: "find",
        content: TEST_FIND_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "cut",
        content: TEST_CUT_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "ed",
        content: TEST_ED_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "sed",
        content: TEST_SED_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "uniq",
        content: TEST_UNIQ_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "xargs",
        content: TEST_XARGS_FILE_CONTENT
      },
      {
        parent_dir: "cli",
        basename: "ssh",
        content: TEST_SSH_FILE_CONTENT
      },
      {
        parent_dir: "cli/third-party",
        basename: "claude",
        content: TEST_CLAUDE_FILE_CONTENT
      },
      {
        parent_dir: "cli/third-party",
        basename: "gh",
        content: TEST_GH_FILE_CONTENT
      },
      {
        parent_dir: "cli/third-party",
        basename: "mise",
        content: TEST_MISE_FILE_CONTENT_1
      },
      {
        parent_dir: "cli/third-party",
        basename: "nkf",
        content: TEST_NKF_FILE_CONTENT
      },
      {
        parent_dir: "cli",
        basename: "units",
        content: TEST_UNITS_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "apply",
        content: TEST_APPLY_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "checkout",
        content: TEST_CHECKOUT_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "config",
        content: TEST_CONFIG_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "diff",
        content: TEST_DIFF_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "gitignore",
        content: TEST_GITIGNORE_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "merge",
        content: TEST_MERGE_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "push",
        content: TEST_PUSH_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "reset",
        content: TEST_RESET_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "rev-parse",
        content: TEST_REV_PARSE_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "upstream",
        content: TEST_UPSTREAM_FILE_CONTENT
      },
      {
        parent_dir: "how-to",
        basename: "data-exchanger",
        content: TEST_DATA_EXCHANGER_FILE_CONTENT
      },
      {
        parent_dir: "how-to",
        basename: "server",
        content: TEST_SERVER_FILE_CONTENT
      },
      {
        parent_dir: "lang/css",
        basename: "hover",
        content: TEST_HOVER_FILE_CONTENT
      },
      {
        parent_dir: "lang/javascript",
        basename: "console",
        content: TEST_CONSOLE_FILE_CONTENT
      },
      {
        parent_dir: "lang/javascript",
        basename: "map",
        content: TEST_MAP_FILE_CONTENT
      },
      {
        parent_dir: "lang/javascript",
        basename: "package-json",
        content: TEST_PACKAGE_JSON_FILE_CONTENT
      },
      {
        parent_dir: "lang/lua",
        basename: "lua",
        content: TEST_LUA_FILE_CONTENT
      },
      {
        parent_dir: "lang/perl",
        basename: "oneliner",
        content: TEST_ONELINER_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "bundle",
        content: TEST_BUNDLE_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "compare",
        content: TEST_COMPARE_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "minitest",
        content: TEST_MINITEST_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "rake",
        content: TEST_RAKE_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "start-project",
        content: TEST_START_PROJECT_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "type-check",
        content: TEST_TYPE_CHECK_FILE_CONTENT
      },
      {
        parent_dir: "lang",
        basename: "test-assertion",
        content: TEST_TEST_ASSERTION_FILE_CONTENT
      },
      {
        parent_dir: "memo",
        basename: "memo-summary",
        content: TEST_MEMO_SUMMARY_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "command",
        content: TEST_COMMAND_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "keymap",
        content: TEST_KEYMAP_FILE_CONTENT
      },
      {
        parent_dir: "neovim/plugin",
        basename: "netrw",
        content: TEST_NETRW_FILE_CONTENT
      },
      {
        parent_dir: "neovim/plugin",
        basename: "vim-pack",
        content: TEST_VIM_PACK_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "read-only",
        content: TEST_READ_ONLY_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "text-objects",
        content: TEST_TEXT_OBJECTS_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "virtual-text",
        content: TEST_VIRTUAL_TEXT_FILE_CONTENT
      },
      {
        parent_dir: "setting",
        basename: "docker-compose",
        content: TEST_DOCKER_COMPOSE_FILE_CONTENT
      },
      {
        parent_dir: "setting",
        basename: "editorconfig",
        content: TEST_EDITORCONFIG_FILE_CONTENT
      },
      {
        parent_dir: "setting",
        basename: "mise",
        content: TEST_MISE_FILE_CONTENT_2
      },
      {
        parent_dir: "shell/bash",
        basename: "bash",
        content: TEST_BASH_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "exit-status",
        content: TEST_EXIT_STATUS_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "for",
        content: TEST_FOR_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "parameter-expansion",
        content: TEST_PARAMETER_EXPANSION_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "shebang",
        content: TEST_SHEBANG_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "special-parameters",
        content: TEST_SPECIAL_PARAMETERS_FILE_CONTENT
      },
      {
        parent_dir: "shell/zsh",
        basename: "command-history",
        content: TEST_COMMAND_HISTORY_FILE_CONTENT
      },
      {
        parent_dir: "tui",
        basename: "emacs",
        content: TEST_EMACS_FILE_CONTENT
      },
      {
        parent_dir: "tui",
        basename: "lazygit",
        content: TEST_LAZYGIT_FILE_CONTENT
      },
      {
        parent_dir: "tui",
        basename: "tmux",
        content: TEST_TMUX_FILE_CONTENT
      }
    ].freeze
  end
end
