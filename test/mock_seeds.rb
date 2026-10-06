# frozen_string_literal: true

module Memo
  module MockSeed
    TEST_CLI_THIRD_PARTY_MISE_FILE_CONTENT = <<~CLI_THIRD_PARTY_MISE_FILE
      ---
      tags: ["CLI", "External Command", "Package Manager", "Runtime Version Manager"]
      ---
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
    CLI_THIRD_PARTY_MISE_FILE

    TEST_SETTING_MISE_FILE_CONTENT = <<~SETTING_MISE_FILE
      ---
      tags: ["toml", "duplicated filenames", "Tips"]
      ---
      ## mise.md
      ### mise.toml
      - mise.tomlを読み取る順番(抜粋)
          - ~
          - .config/mise.toml        (local)
          - .cinfig/mise/config.toml (dotfiles)
          - ~

      ### install
      ```bash
      # mise install でそれぞれのmise.toml をみてパッケージをインストールする
      mise install
      ```
    SETTING_MISE_FILE

    TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT = <<~ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE
      ---
      tags: ["Terminal", "Charactor"]
      ---
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
      ---
      tags: ["bash", "CLI", "builtin", "Command inspection"]
      ---
      ## alias: CLIにエイリアスを付ける
      ```bash
      ## aliasを実行すると、その環境のエイリアスの一覧が見れる
      alias
      ```
    ALIAS_FILE

    TEST_COMMAND_FILE_CONTENT = <<~COMMAND_FILE
      ---
      tags: ["bash", "CLI", "builtin", "Command inspection"]
      ---
      ## command (bash builtin command)

      ### 例
      ```
      # シェル関数やエイリアスを無視して、元のコマンドや、外部プログラムを直接実行するために使う
      ## 例
      ## エイリアスなしのls を実行する
      command ls

      ## -v エイリアスなどがあれば、その情報を表示する
      command -v ls
      > alias ls='ls -GpF'



      ## -V そのコマンドが組み込み関数かどうかの情報を取得する
      ### 例1: cd
      command -V cd
      > cd is a shell builtin

      ### 例2: gs
      command -V gs
      gs is an alias for git status
      ```
    COMMAND_FILE

    TEST_CHMOD_FILE_CONTENT = <<~CHMOD_FILE
      ---
      tags: ["bash", "CLI", "File and Directory", "edit", "completion"]
      ---
      ## chmod: ファイルモードとアクセス権限を変更するコマンド

      ### ZSH でのchmod のオプション補完
      - chmodと入力した後にTABを入力すると次のようなオプションの一覧が表示される。 便利。

      ```
      a  -- all
      g  -- group
      o  -- others
      u  -- owner
      -   +   =
      ```
    CHMOD_FILE

    TEST_REALPATH_FILE_CONTENT = <<~REALPATH_FILE
      ---
      tags: ["bash", "CLI", "File and Directory", "表示"]
      ---
      ## realpath: 実体の方のパスを返す
      - How to
      ```bash
      realpath <filename>
      ```

      - ユースケース
      ```bash
      # フルパスを取得してpbcopyに渡す
      realpath <filename> | pbcopy
      ```
    REALPATH_FILE

    TEST_KILL_FILE_CONTENT = <<~KILL_FILE
      ---
      tags: ["bash", "CLI", "process", "terminate"]
      ---
      ## kill: プロセスを終了させるか、プロセスにシグナルを送信する

      ### 例: プロセスを終了させる
      ```bash
      ## -9オプションを使う
      kill -9 <PID>
      ```
    KILL_FILE

    TEST_PS_FILE_CONTENT = <<~PS_FILE
      ---
      tags: ["bash", "CLI", "process", "表示", "配列"]
      ---
      ## ps: プロセスのステータスを確認する

      ### オプション
      a - 端末のあるプロセス表示
      c - 実行コマンドのパスを省略する
      u - 実行ユーザー名表示
      x - 端末のないプロセス表示
      e - 環境変数を表示

      ## 例
      - 子プロセスの確認(PPID)
      ```bash
      ## どちらかを使う
      aux -o ppid
      aux -ef
      ```

      ## 実行プロセスの集計
      ```
      $ ps aux | cut -w -f11 | xargs basename | sort | uniq -c | sort -r
      ```

      - basenameを使わなくてもcオプションで同じことができる
      ```
      $ ps acux | cut -w -f11 | sort | uniq -c | sort -r
      ```
    PS_FILE

    TEST_GREP_FILE_CONTENT = <<~GREP_FILE
      ---
      tags: ["bash", "CLI", "search", "bulk", "pipe", "recursive"]
      ---
      ## grep: 文字列検索

      - 例
      ```bash
      ## 基本形
      # grep <word> <file>
      grep ls foo.txt

      ## -Rオブションを付ければfindからパイプで渡す必要もない
      ## -R: ディレクトリの中を再帰的に検索する
      grep -R "ls" memo/

      ## memoフォルダの中にあるファイルを一括してgrepする
      ## xargsに渡すからかalias grep='grep --color=auto'が効かない
      find memo -type f | xargs grep --color=auto "foo"

      ## --includeで特定のファイル名に該当するものだけを検索できる
      grep -R "ls" --include="*.md" memo/

      ## -cオプションでそのファイルに何回その単語が現れたかを数えることができる
      grep -Rc "ls" memo/

      ## -lオプションでその単語が現れたファイルだけを表示する
      grep -Rl "ls" memo/
      ```
    GREP_FILE

    TEST_CLI_CORE_TEXT_DIFF_FILE_CONTENT = <<~CLI_CORE_TEXT_DIFF_FILE
      ---
      tags: ["bash", "CLI", "text"]
      ---
      ## diff: ファイルやディレクトリの差分を取得する

      - origfileとpatchfileの内容が次の場合、diffの結果は次の通り
      ```bash
      cat origfile
      > 1
      > 12
      > 123

      cat patchfile
      > 123
      > 123
      > 123

      diff origfile patchfile
      ```

      ```diff
      1,2d0
      < 1
      < 12
      3a2,3
      > 123
      > 123
      ```

      - a unified diff形式(-uオプション)
      ```
      # -u を付けると、 a unified diff の形式で差分を出力する
      # 先頭の三行に、パッチファイルとパッチを当てるファイルの情報と、差分の概要を出力する
      # patch コマンドは、この情報をみて、パッチファイルとパッチを当てるファイルを識別する
      # なお、-c オプションでも同様の情報を出力する。-c の場合は、context diffs の形式でこの情報を出力する

      # a unified diff について
      # --- が付いている方がパッチを当てる方のファイル("old")
      # +++ が付いている方がパッチファイル("new")

      diff -u origfile patchfile
      ```

      ```diff
      --- origfile	2026-05-22 08:53:21
      +++ patchfile	2026-05-22 08:53:27
      @@ -1,3 +1,3 @@
      -1
      -12
       123
      +123
      +123
      ```

      #TODO origfileにパッチファイルを適用する
      # diff からパイプでpatchに繋げるとreversed patchと判定されるときがある
      ```bash
      diff -u origfile patchfile | patch -u
      ```
    CLI_CORE_TEXT_DIFF_FILE

    TEST_NL_FILE_CONTENT = <<~NL_FILE
      ---
      tags: ["bash", "CLI", "text", "表示", "集計"]
      ---
      ## 例
      - 行番号を付けて表示する
      ```sh
      nl test.txt
      ```
    NL_FILE

    TEST_SED_FILE_CONTENT = <<~SED_FILE.freeze
      ---
      tags: ["bash", "CLI", "text", "substitute", "edit"]
      ---
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

    TEST_TR_FILE_CONTENT = <<~TR_FILE
      ---
      tags: ["bash", "CLI", "text", "substitute", "edit", "filter", "remove"]
      ---
      ## tr: 標準出力からの文字列を置換・削除するコマンド

      - 例
      ```bash
      ## PATHの一覧を取得する
      env | grep ^PATH | tr ":" "\n"
      ```
    TR_FILE

    TEST_WC_FILE_CONTENT = <<~WC_FILE.freeze
      ---
      tags: ["bash", "CLI", "text", "表示", "集計"]
      ---
      ## オプション
      出力される数値は、行数・単語数・バイト数の順番で並んでいる#{'  '}

      - -l: 行数のみ出力
      - -c: バイト数のみ出力
      - -m: 文字数でカウント。通常はUTF-8で数える。日本語も一文字としてカウント
      - -w: 単語数のみ出力。日本語だと使う意味がそこまでない。
    WC_FILE

    TEST_IFCONFIG_FILE_CONTENT = <<~IFCONFIG_FILE
      ---
      tags: ["CLI", "Network", "表示"]
      ---
      ## オプション
      - `-l`: 利用可能な全てのインターフェイスのみを表示する

      - 自機IPの調べ方
      ```bash
      # 無線の場合
      ipconfig getifaddr en0

      # 有線の場合
      ipconfig getifaddr en1
      ```

      ## ネットワークインターフェイス
      ### 主なインターフェイス

      | 名前 | 種類 | 説明 |
      |------|------|------|
      | `en0` | Ethernet/Wi-Fi | 通常は Wi-Fi（MacBook系） |
      | `en1` | Ethernet/Wi-Fi | 有線LAN or 2枚目の無線 |
      | `lo0` | Loopback | ループバック（127.0.0.1）、仮想 |
      | `utun0〜` | VPN/Tunnel | VPNや内部トンネル |
      | `bridge0` | Bridge | 仮想ブリッジ（仮想マシン等） |
      | `awdl0` | AirDrop | AirDrop/Handoff用の無線 |

      - ネットワークインターフェイスの一覧
      ```bash
      ipconfig -l
      ```

      - Macなら`networksetup -listallhardwareports`を実行すると全てのネットワークハードウェアの一覧が取得できる
    IFCONFIG_FILE

    TEST_TCPDUMP_FILE_CONTENT = <<~TCPDUMP_FILE
      ---
      tags: ["CLI", "Network"]
      ---
      ## tcpdump: ネットワークの交信ログを取得
      - 使い方
      ```bash
      ## 対象のインターファイスを指定すること
      tcpdump -i en0
      ```
    TCPDUMP_FILE

    TEST_CLAUDE_FILE_CONTENT = <<~CLAUDE_FILE
      ---
      tags: ["CLI", "External Command", "AI", "CLI client"]
      ---
      # claude CLI
      - `/resume`
      過去のセッションを選択して再開する
    CLAUDE_FILE

    TEST_GH_FILE_CONTENT = <<~GH_FILE
      ---
      tags: ["CLI", "Third Party", "git", "CI/CD", "CLI client"]
      ---
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

    TEST_NKF_FILE_CONTENT = <<~NKF_FILE
      ---
      tags: ["CLI", "External Command", "text", "表示", "変換", "Character Inspection", "edit"]
      ---
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
      ---
      tags: ["CLI"]
      ---
      - units: 単位の計算ができる
          - mac版だと'/usr/share/misc/units.lib'に使える単位の一覧がある
    UNITS_FILE

    TEST_BRANCH_FILE_CONTENT = <<~BRANCH_FILE
      ---
      tags: ["CLI", "git", "Branching and Merging"]
      ---
      - branch: ブランチの作成など
      ```bash
      # 基本: ブランチの作成
      git branch <branch>

      # 特定のコミット・ブランチから新しいブランチを作成するが、そのブランチには切り替えない場合
      git branch <branch> <commit>

      # ブランチを新規作成して、そのブランチに切り替えるならgit switchが使える
      git switch -c <branch>
      ```
    BRANCH_FILE

    TEST_CONFIG_FILE_CONTENT = <<~CONFIG_FILE
      ---
      tags: ["CLI", "git", "Setting"]
      ---
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

    TEST_GIT_DIFF_FILE_CONTENT = <<~GIT_DIFF_FILE
      ---
      tags: ["CLI", "git", "Basic Snapshotting", "Comparison Version", "Patching"]
      ---
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
    GIT_DIFF_FILE

    TEST_GITIGNORE_FILE_CONTENT = <<~GITIGNORE_FILE
      ---
      tags: ["git", "Git Guides", "Setting"]
      ---
      - .gitignore
      ## ローカル環境だけでgitignoreを設定するには
      .git/info/excludeに該当のファイル・フォルダ名を書けばいい
    GITIGNORE_FILE

    TEST_MERGE_FILE_CONTENT = <<~MERGE_FILE
      ---
      tags: ["CLI", "git", "Branching and Merging"]
      ---
      ## git merge
      ```bash
      # git squashしてマージ
      git merge --squash origin/feature/foo

      # コンフリクトの事前確認
      git merge --no-commit --no-ff feature/foo
      ```
    MERGE_FILE

    TEST_PULL_FILE_CONTENT = <<~PULL_FILE
      ---
      tags: ["CLI", "git", "Sharing and Updating Projects"]
      ---
      ## pull: リモートからブランチを取得し、ローカルのブランチとマージする

      ### ローカルとリモートの履歴が分岐していた場合のwaringについて
      1. pull.ff only: fast-forwardできる場合だけpull。分岐していたらエラー
      2. pull.rebase true: ローカルのコミットをリモートブランチの先頭に載せる
      3. pull.rebase false: マージコミットを作成して統合する

      #### 設定方法
      ```bash
      # 1.の場合
      git config --global pull.ff only

      # 2.の場合
      git config --global pull.rebase true
      ```
    PULL_FILE

    TEST_REBASE_FILE_CONTENT = <<~REBASE_FILE
      ---
      tags: ["CLI", "git", "Patching"]
      ---
      ## rebase: Reapply commits on top of another base tip

      ## 例
      ```bash
      ## 対話的にリベースする場合
      ### 例: 直前の二つのコミットをsquashしたい場合
      ### 直前の二つのコミットHEAD~2を指定して、リベース用のエディタを開く
      git rebase -i HEAD~2
      ## -> 二番目のコミットのpickをs(squash)に変更して保存する。
      ```
    REBASE_FILE

    TEST_RESTORE_FILE_CONTENT = <<~RESTORE_FILE
      ---
      tags: ["CLI", "git", "Basic Snapshotting"]
      ---
      - `git restore`: ファイルの復元

      ```bash
      # staged ではないファイルを元に戻す
      git restore <filename>

      # staged のファイルを not staged に戻す
      git restore --staged <filename>
      ```
    RESTORE_FILE

    TEST_SWITCH_FILE_CONTENT = <<~SWITCH_FILE
      ---
      tags: ["CLI", "git", "Branching and Merging", "legacy"]
      ---
      ## `git switch`: ブランチの操作

      ```bash
      # ブランチの切り替え
      git switch <branch>

      # 新規ブランチを作成して切り替え
      git switch -c <branch>

      # 特定のコミット・ブランチから新しいブランチを作成して、そのブランチに切り替える場合
      git switch -c <branch> <commit>
      ```

    SWITCH_FILE

    TEST_GITLAB_FILE_CONTENT = <<~GITLAB_FILE
      ---
      tags: ["SaaS"]
      ---
      ## gitlab: コード管理プラットフォーム

      ### SSHキー問題
      - SSHキーを手順通りに設定してもすぐdeniedとなってしまっていた
          - SSHキーが複数あると~/.ssh/id_rsaかid_ed25519を読み取ってしまう
          - そのため、次のドキュメントに従って適切なキーを設定すること
              - https://docs.gitlab.com/user/ssh_troubleshooting/#error-permission-denied-publickey
    GITLAB_FILE

    TEST_DIRECTORY_FILE_CONTENT = <<~DIRECTORY_FILE
      ---
      tags: ["How to", "Directory"]
      ---
      ## directory: ディレクトリ構成図を書くときに使う記号

      - 例
      ```
      home/
      ├─ foo/
      │  ├── file1.txt
      │  ├── file2.txt
      │  └── file3.txt
      ├─ bar/
      ├─ bar/
      └─ qux/
      ```
    DIRECTORY_FILE

    TEST_SERVER_FILE_CONTENT = <<~SERVER_FILE
      ---
      tags: ["How to", "Network"]
      ---
      - server: 簡易的なWebサーバーを起動させる方法
      ```bash
      # ruby
      ruby -rwebrick -e 'WEBrick::HTTPServer.new({:DocumentRoot => "./"}).start'

      # python
      python3 -m http.server 8000
      ```
    SERVER_FILE

    TEST_AWK_FILE_CONTENT = <<~AWK_FILE
      ---
      tags: ["bash", "CLI", "awk", "text", "edit"]
      ---
      ## awkの基本
      パターンにマッチした行に対してアクションを実行する
      ```
      pattern1 { action1 }
      pattern2 { action2 }
      ```

      ## ビルトイン関数
      - substr
      strの一部を抽出する
      ```
      substr(str, start[, length])
      ```

      ## オプション
      - `-v`: awkから参照可能な変数を指定する

      ## セパレーター
      - FS: 入力時のフィールドセパレーター
          - デフォルトは空白文字で、デフォルトだとタブや改行文字もセパレーターとして認識されるとのこと

      - RS: 入力時のレコードセパレーター
          - デフォルトは改行文字


      ## 例
      - 長い行を削除してファイルを表示する
      ```bash
      cat error.log | awk 'length($0) <= 100 { print $0 }'
      ```

      - フィールドセパレーターをタブ文字に指定する
      -
      ```bash
      memo tags -c | awk -v FS="\t" '$1 == 1 { print $2 }'
      ```
    AWK_FILE

    TEST_LANG_JAVASCRIPT_ARRAY_FILE_CONTENT = <<~LANG_JAVASCRIPT_ARRAY_FILE
      ---
      tags: ["JavaScript", "配列", "データ構造"]
      ---
      - Array
      ```javascript
      # 配列の最後の値を取得するのにat() が使えるようになった
      arr.at(-1);

      # 配列の内、最後だけを取り除く場合slice() が使える
      arr.slice(0, -1)
      ```
    LANG_JAVASCRIPT_ARRAY_FILE

    TEST_JSDOC_FILE_CONTENT = <<~JSDOC_FILE.freeze
      ---
      tags: ["JavaScript", "Annotation", "Notation"]
      ---
      ## JSDoc の書き方
      ```javascript
      ## Array
      # ex.1
      /** @type {Array<number>} */

      # ex.2
      /**
       * URL の文字列を処理する
       *#{' '}
       * @param {Array<string>} urls - URL の文字列#{' '}
       */
       const processUrls = (urls) => processedUrls;

       ## string
       ### 先頭のアルファベットは小文字のはず
      /**
       * string か boolean
       *
       * @type {(string | boolean)}
       */
      var sb;
      ```
    JSDOC_FILE

    TEST_NPM_FILE_CONTENT = <<~NPM_FILE
      ---
      tags: ["JavaScript", "Package Manager", "Setting", "CLI"]
      ---
      - npm: パッケージマネージャー
      ```bash
      ## グローバルにインストールしたコマンドの確認
      npm list -g

      ## こちらの方が見やすい場合があるかも
      npm list -g --depth=0

      ## npx: ローカルかリモートのnpmパッケージを実行
      ## -> pnpm dlxと違いローカルのパッケージを使用して実行することもあるみたい
      npx jest
      ```

    NPM_FILE

    TEST_PNPM_FILE_CONTENT = <<~PNPM_FILE
      ---
      tags: ["JavaScript", "Package Manager", "Setting", "CLI"]
      ---
      - pnpm: パッケージマネージャー
      ```bash
      ## exec: プロジェクトのスコープでコマンドを実行
      pnpm exec textlint

      ## 他のコマンドと被らなければexecは省略可能
      pnpm textlint

      ## pnpm dlx (alias pnpx): レジストリから直接取得し、コマンドを実行
      ## dlx => execにするには、該当のパッケージをpnpm addで追加すればよい
      pnpx create-vue my-app
      pnpm dlx create-vue my-app
      # ドキュメントにはpnxのaliasesがpnpm dlx, pnpxとあるが、pnxだけが今の環境だと動かない
      # ref: https://pnpm.io/ja/cli/pnx

      # パッケージのインストール
      # バージョンを正確に指定するには--save-exact, -Eを使う
      pnpm add -E tsx
      # コマンドのグローバルインストールも可能
      pnpm add -g textlint

      # グローバルコマンドのリストを確認
      pnpm list -g

      # そしてアンインストールする場合
      pnpm uninstall -g textlint
      ```

      ## 設定: pnpm-workspace.yaml
      ```yaml
      allowBuilds:
        # JavaScriptのバンドラーを有効にする
        esbuild: true
      # キャレットを付けず、正確なバージョンをpackage.jsonに記載する
      saveExact: true
      # パッケージが公開されてから指定した時間(分)以上経過しないと、そのパッケージをインストールできないようにする。
      # デフォルトは1440分(１日)
      minimumReleaseAge: 1440
      ```
    PNPM_FILE

    TEST_NAMING_CONVENTION_FILE_CONTENT = <<~NAMING_CONVENTION_FILE
      ---
      tags: ["命名規則", "引数"]
      ---
      ## 命名規則
      - プログラミングで大事な命名の、その規則や習慣について

      - 対になっている
          - synonym antonym dictionaryがあったらいいかも
          Entry <-> Collection

      ### 引数の命名規則: arguments
      - argc(Argument Count)
          - 引数の数を表す
          - 慣用上、C, C++などで使われる

      - argv(Argument Vector)
          - 引数の要素(文字列の配列)を表す
          - 慣用上、C, C++などで使われる

      - args(Arguments)
          - 引数全体を表す
          - 慣用上、JavaやPythonで使われる
    NAMING_CONVENTION_FILE

    TEST_UV_FILE_CONTENT = <<~UV_FILE
      ---
      tags: ["CLI", "Python", "Package Manager", "Project Manager"]
      ---
      ## uv: Pythonのパッケージ＆プロジェクトマネージャー

      ### インストールなど
      ```bash
      # homebrewでインストール可能
      brew install uv
      ```

      ### プロジェクトの作成・実行
      ```bash
      # helloフォルダが作成され、その中にプロジェクトの雛形が作成される
      uv init hello

      # プロジェクトの実行
      cd hello/
      uv run hello
      ```

      ### パッケージの追加・管理
      ```bash
      # 対象のパッケージをrequestsとする
      # シンプリに追加
      uv add requests

      # バージョン指定
      uv add 'requests==2.31.0'

      # requirements.txtから追加する場合は、-rオプションを指定する
      uv add -r requirements.txt -c constraints.txt

      # 削除
      uv remove requests

      # パッケージのアップデート
      uv lock --upgrade-package requests
      ```
    UV_FILE

    TEST_LANG_RUBY_ARRAY_FILE_CONTENT = <<~LANG_RUBY_ARRAY_FILE
      ---
      tags: ["Ruby", "配列", "Creation", "Concatenation", "データ構造"]
      ---
      # Array: 配列について

      ## 配列の結合
      - `<<, push, concat, +`について
          - <<: 配列の末尾に破壊的に要素を追加する
              ```ruby
              arr = [1,2,3]
              # => [1, 2, 3]
              arr << 4
              # => [1, 2, 3, 4]
              ```

          - push: 指定された要素を順番に配列の末尾に追加する
              - docs: https://docs.ruby-lang.org/ja/latest/method/Array/i/append.html
              ```ruby
              array = [1, 2, 3]
              array.push 4
              array.push [5, 6]
              array.push 7, 8
              # => [1, 2, 3, 4, [5, 6], 7, 8]
              ```

          - concat: 配列の末尾に破壊的に配列を追加する
              ```ruby
              arr = [1, 2, 3]
              # => [1, 2, 3]
              arr.concat([4, 5, 6])
              # => [1, 2, 3, 4, 5, 6]
              ```

          - +: 自分と他の配列同士を繋げた配列を生成して返す
    LANG_RUBY_ARRAY_FILE

    TEST_BUNDLE_FILE_CONTENT = <<~BUNDLE_FILE
      ---
      tags: ["CLI", "Ruby", "Project Manager", "Dependency Management"]
      ---
      ## bundle: パッケージの依存関係を管理するためのCLIアプリ

      ### コマンドの一覧を見る方法(zsh)
      ```zsh
      # gemと打った後、スペースを一つ入れてTabを押すと、サブコマンドの一覧が見れる
      bundle <TAB>
      ```

      ### プロジェクトの作成
      ```bash
      # Gemfileを作成する
      bundle init

      # 使いたいパッケージを追加する
      bundle add minitest

      # 作成されるGemfileに使いたいパッケージを記載してもいい
      gem "rails", "~>8.1"

      # パッケージをインストールする
      bundle install
      ```

      ### プロジェクトごとに使用するコマンド
      ```bash
      # そのプロジェクトの全てのgemを確認する
      bundle show

      # そのプロジェクトのパッケージを読み込んだ状態でirbにログインする
      bundle exec irb
      ```

      ### rakeとbundle exec rakeの違い
      - `rake` -> システムにインストールされた`rake`を使う
      - `bundle exec rake` -> Gemfile.lockで固定されたバージョンの方の`rake`を使う

      ### bundle gem
      ```bash
      # rubygem を作るための雛形を作成するコマンド
      # <name> -> . とすればカレントディレクトリが指定される
      # Gemfile や README が既にあると、上書きしていいかどうか聞かれる
      bundle gem <name>
      ```

      ### bundler/gem_tasks
      ```ruby
      # Rakefileでbundler/gem_tasksをインポートすると、build, release, installなどが行える
      require "bundler/gem_tasks"
      ```
    BUNDLE_FILE

    TEST_COMPARE_FILE_CONTENT = <<~COMPARE_FILE
      ---
      tags: ["Ruby", "比較"]
      ---
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
      ---
      tags: ["Ruby", "Testing Framework"]
      ---
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

    TEST_PRINT_FILE_CONTENT = <<~PRINT_FILE
      ---
      tags: ["Ruby", "print", "配列", "比較", "標準出力"]
      ---
      ## print: 標準出力への表示、puts, p, ppとの比較

      ### 配列とprint
      ```ruby
      ## 配列を定義する
      arr1 = ["foo", "bar", "baz"]

      ## putsだと改行した文字列として表示される
      puts arr1
      foo
      bar
      baz

      ## printだと配列がそのまま標準出力に書き出される
      ## また、print自体は何も返さない
      print arr1
      ["foo", "bar", "baz"] # => nil

      ## pだと配列をそのまま表示し、p自身も表示したものと同様のものを返す
      p arr1
      ["foo", "bar", "baz"]
      => ["foo", "bar", "baz"]
      ```
    PRINT_FILE

    TEST_RUBY_FILE_CONTENT = <<~RUBY_FILE
      ---
      tags: ["Ruby", "CLI", "documentation"]
      ---
      ## Ruby
      - manコマンドでCLIのrubyコマンドの使い方を見ることができる
          - テストで何が行われているかとか、ワンライナーの書き方とかで参考になるかも
      ```bash
      man ruby
      ```
    RUBY_FILE

    TEST_STRUCT_FILE_CONTENT = <<~STRUCT_FILE
      ---
      tags: ["Ruby", "連想配列", "構造体", "データ構造", "値オブジェクト"]
      ---
      ## Struct: 構造体を作成するクラス、およびHash, Dataとの比較

      ### Structと、HashとDataとの比較・使い分け
      - Hashは動的、Struct、Dataは静的
          - Hashはキーが事前に決まってない場合に使う
          - Struct, Dataは構造自体は先に決まっているものに使う

      ### その他
      1. Hashの値は数値、文字列、シンボルなどが良く、配列あたりのオブジェクトは望ましくないらしい
      2. それ以上、複雑なデータ構造を作成するならDataやStructを使う
      3. でも、その中間のようなデータ構造はあるよなあ...
    STRUCT_FILE

    TEST_YARD_FILE_CONTENT = <<~YARD_FILE
      ---
      tags: ["Ruby", "Generate documentation"]
      ---
      ## yard: ドキュメント生成のためのライブラリ

      ### 記法
      - 次のドキュメントが参考になる
          - https://rubydoc.info/gems/yard/file/docs/GettingStarted.md#Declaring_Types
      - YARD Type Parserというものもある
          https://yardoc.org/types.html

      #### 例
      - 戻り値がStringかnilの場合: `@return [String, nil]`
      - キーが文字列で値がシンボルか数値の場合: `Hash{String => Symbol, Number}`
    YARD_FILE

    TEST_FORMAT_FILE_CONTENT = <<~FORMAT_FILE
      ---
      tags: ["meta", "format"]
      ---
      ## format: メモフォルダをtextlintでフォーマットするための準備
      ```bash
      # textlintと日本語のスペース関連のプリセットをグローバルにインストール
      pnpm add -g textlint textlint-rule-preset-ja-spacing

      # ファイル名は必ず引用符で括る必要がある(自分の環境だけ？)
      textlint --preset preset-ja-spacing "README.md"
      ```
    FORMAT_FILE

    TEST_BUFFER_FILE_CONTENT = <<~BUFFER_FILE
      ---
      tags: ["neovim", "buffer", "Command Line Mode"]
      ---
      ## buffer

      ### バッファの切り替え
      ```
      # 次のバッファへ
      :bn(:bnext)

      # 前のバッファへ
      :bp(:bprevious)

      # 直前のバッファへ
      :b#

      # バッファの番号を指定して移動する
      :b <number>
      ```

      ### バッファの一覧を確認する
      ```
      :ls
      ```
    BUFFER_FILE

    TEST_COMMENTING_FILE_CONTENT = <<~COMMENTING_FILE
      ---
      tags: ["neovim", "Comment Out", "documentation"]
      ---
      ## commenting: コメントアウトなどの操作
          1. ビジュアルモードでgcと打つと大体コメントアウトできる
          2. ノーマルモードでgccと打つとその行だけコメントアウトできる

      ## ドキュメントの探し方
      ```
      # ドキュメントはcommenting で検索する
      :h commenting
      ```
    COMMENTING_FILE

    TEST_NEO_TREE_FILE_CONTENT = <<~NEO_TREE_FILE
      ---
      tags: ["neovim", "plugin", "documentation"]
      ---
      ## neo-tree
      - サイドバーにファイルツリーが表示されるneovimのファイラープラグイン

      ### ファイルツリー内での操作
      - ヘルプをみる: ?
      - 隠しファイルを表示/非表示するトグル: H
      - ファイルツリーの更新: R
      - ファイルの追加: a
      - ディレクトリの追加: A

      ### ドキュメント
      - 次のコマンドで確認できる
      - :h neo-tree | only

    NEO_TREE_FILE

    TEST_NVIM_SURROUND_FILE_CONTENT = <<~NVIM_SURROUND_FILE
      ---
      tags: ["neovim", "plugin", "Operator", "Normal Mode", "documentation"]
      ---
      - nvim-surround
          - 文字列を記号で囲ってくれる
          - https://github.com/kylechui/nvim-surround

      {example}
      - ドキュメント
      :h nvim-surround | only
          - ドキュメントに便利なエイリアス集などが載っている

      ### 例
      - 単語をHTMLタグで囲むには
          `ysiwth1`
          - タグを変更するには
              `csth2`

      ## 使い方(ドキュメントから)

          Old text                    Command         New text
      --------------------------------------------------------------------------------
          # 単語単位でスペースを入れずにシンボルでくくる -> ysiw
          surr*ound_words             ysiw)           (surround_words)
          surr*ound_words             ysiw(           ( surround_words )
          # 現在のカーソルから文末までシンボルでくくる
          *make strings               ys$"            "make strings"
          # くくってあるシンボルを消す -> ds
          [delete ar*ound me!]        ds]             delete around me!
          remove <b>HTML t*ags</b>    dst             remove HTML tags
          # くくってあるシンボルを変更する -> cs<old-symbol><new-symbol>
          'change quot*es'            cs'"            "change quotes"
          <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
          delete(functi*on calls)     dsf             function callsv
    NVIM_SURROUND_FILE

    TEST_READ_HELP_FILE_CONTENT = <<~READ_HELP_FILE
      ---
      tags: ["neovim", "documentation"]
      ---
      ## ドキュメント・help の読み方
      ### nvim のドキュメント
      ```bash
      man nvim
      ```
      - neovimのWebドキュメント: https://neovim.io/doc/user/

      ### help の読み方 (vim と共通)
      - helpを全画面で見る
      ```
      :h | only
      # それか<Ctrl-W> H を押して、高さを最大にする
      # なお、<Ctrl-W> K を押して、幅を最大にすると、高さが半分になってしまう

      # ユーザーマニュアルの目次を開く
      :h user-manual

      # 指定した項目を開く
      :h usr_06.txt

      # キーの表記法(Key Notation) を確認する
      :h key-notation

      # vim.keymap.set へ移動するには
      <- :h -> lua の項目だった
      1. :h | only
      2. -> vim-script の項目へ移動する
          - vim が付くものはvim-script の領域みたい
      3. keymap で検索して、ジャンプしていけば、vim.keymap.set のドキュメントに辿り着く

      # 定義へ移動、元のページに戻る
      ## Ctrl+] でそのキーワードの詳細へ移動する
      ## Ctrl+T, Ctrl+O で元の場所に戻る
      ```

      ### helpgrep
      ```
      ## neovim のhelp の中を検索する
      :helpgrep <word>

      ## 次の検索結果に移動するには
      :cn, :cne, :cnext
      -> ]q でも移動できる
      ```


    READ_HELP_FILE

    TEST_SCRIPT_FILE_CONTENT = <<~SCRIPT_FILE
      ---
      tags: ["neovim"]
      ---
      ## Neovim のスクリプト作成
      ```
      # 組み込み関数のリスト
      :help function-list
      # 組み込み関数の詳細
      :help vimscript-functions

      # 定義へ移動、元のページに戻る
      ## Ctrl+] でそのキーワードの詳細へ移動する
      ## Ctrl+T, Ctrl+O で元の場所に戻る
      ```

      ## スクリプトを実行
      ```
      # コマンドラインモードで%lua と打つと、そのバッファがluaで実行される
      # line() などの組み込みコマンドはvim.fn.line() などとする必要がある
      :%lua

      # または-l オプションを付けて実行する
      nvim -l script.lua

      # スクリプトの作成・デバッグ
      # -u で設定ファイルを指定して読み込む
      nvim -u script.lua <filename>

      # 例
      ## keymap.lua を読み込んで files.js を編集する
      nvim -u keymap.lua files.js
      ```

      - 注意: デフォルトの設定ファイルは読み込まれなくなってしまう
      - swapfileに関する警告が出るので、swapfile = falseを追加しておくといい
      ```lua
      vim.opt.swapfile = false
      ```

    SCRIPT_FILE

    TEST_TIPS_FILE_CONTENT = <<~TIPS_FILE
      ---
      tags: ["neovim", "Tips", "Motion"]
      ---
      ## tips
      `:messages`で過去のメッセージが見れる

      - グローバル変数vimの中の変数の見方
      :lua vim.print(vim.<variables>)
      # 例: vim.pack のパッケージ一覧の見方(WIP)
      :lua vim.print(vim.pack.get({}, {'name'}))

      - 末尾の半角スペースを消去する
      `%s/ $//g`

      - undo, redo
          - undo: u
          - **redo: <C-R>**


      - word-motion: 単語単位の移動
          - https://vim-jp.org/vimdoc-ja/motion.html#word-motions
          - `w`だけでなく、`W`や`e`でも移動できる

      - object-motion: オブジェクト単位での移動
          - https://vim-jp.org/vimdoc-ja/motion.html#object-motions
          - `)`や`]]`で移動できる
    TIPS_FILE

    TEST_REACT_FILE_CONTENT = <<~REACT_FILE
      ---
      tags: ["Frontend"]
      ---
      ## React: フロントエンドライブラリ・UIフレームワーク
      ### Container / Presentational Component
      - Container Component
          - データ取得・状態管理・ビジネスロジック
          - UIを持たず、Presenterにpropsを渡して描画を委譲する

      - Presentational Component
          - UIを担当する
          - propsでデータとコールバックを受け取り、描画するだけ

      - 組み合わせ方
      ```
      # PresenterにContainer Componentを渡さないこと
      Container
      └─ Presenter
      ```
    REACT_FILE

    TEST_DOCKERFILE_FILE_CONTENT = <<~DOCKERFILE_FILE
      ---
      tags: ["Docker"]
      ---
      ## Dockerfile: Dockerイメージをビルドするための設定ファイル

      ### 例
      ```
      ## 例: 簡単なlinux環境を作成して、ホームディレクトリと一般ユーザーを設定する
      ## busyboxはUNIXのCLIが一通り揃っているdockerイメージ
      FROM busybox:latest

      ## j
      RUN adduser -h /home/hy -u 1000 /bin/sh hy

      WORKDIR /home/hy

      USER hy
      ```
    DOCKERFILE_FILE

    TEST_MAKEFILE_FILE_CONTENT = <<~MAKEFILE_FILE
      ---
      tags: ["Task Runner"]
      ---
      ## Makefile: タスクランナーとファイル操作
      - ドキュメント
          - Webにあるgnuのドキュメントを参照する
              - 誰かが個人的に翻訳して？アップロードしたもののようだ

      ## 文法
      ### 基本
      ```make
      # 基本: ルールとターゲット
      # 次のような定義が基本
      <targets>: <prerequisites>
          <command>
      # <prerequisites>に定められたファイルと最終更新日時を比較することにより、ターゲットの方が古ければコマンドを実行する
      # また、ターゲットに定められたファイルが存在しない場合も、コマンドが実行される
      ```

      ### タスクランナーとして
      ```
      # タスクランナーとして転用
      # .PHONYに実行させたいタスクを入れて、そのタスクをtargetsとして記載する
      # -> ファイル作成のためのMakefileを.PHONYを使ってタスクランナーとして転用している

      # 例
      clean:
          rm *.o

      .PHONY: clean
      ```

      ## Makefileを指定して読み込むには
      `make -f <Makefile>` ## `Makefile.wip`などを読み込みたい場合に使う

      ## Makefileの作り方
      ### デバッグ
      1. `make -n`で実行されるコマンドを出力する
      - 例
      ```make
      make -n clean
      ```
      2. 変数の値を表示するには`$(warning ...)`を使う
      - 例
      ```make
      ## $(warning ...)を使う場合
      $(warning objects: $(objects))

      ## 改行して見やすくするには標準出力にリダイレクトしてtrで整形する
      make 2>&1 | tr " " "\n"

      ## このようにすると、ルール行やターゲット行をコメントアウトしたときに、`make`と打っただけでtestが実行されてしまう場合がある
      ## そのため、$(warning ...)を使うこと
      test:;
          @echo $(objects)
      ```

      ## 命名規則
      - ターゲットと変数は小文字にして、それぞれハイフン、アンダースコアで繋ぐべきとされる
          - Ref: https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html#Standard-Targets
      ```make
      test-files:
          @echo $(current_files)
      ```

      ## 変数を定義するには
      - Makefileのユーティリティ関数を使うこと
      ```make
      current_files = $(wildcard *)
      exclude_files = Makefile
      objects = $(filter-out $(exclude_files), $(current_files))
      targets = $(patsubst %,$(HOME)/.%,$(objects))
      ```

      ## 自動変数
      - 詳細はドキュメントを確認すること
          - https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_toc.html#TOC101
          - どの自動変数もそのディレクトリ名やファイル名だけを取得することが可能
      - $@: ターゲット名を表す
      - $<: 最初の依存するファイル名を表す(The name of the first prerequisite)
      - $?: ターゲットより新しい全ての依存するファイル名を表す

      ## ターゲットごとに適用される依存ファイルを変えたい場合
      ```make
      ## パーセント(%)を使う
      $(HOME)/.%: %
      	cp $< $@
      ```

      ## サブディレクトリごとに存在するMakefileを利用するには
      - Recursive Use of makeを参照すること
          - https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_5.html#SEC50

      ## その他: コマンドエコーを出力しないようにするには
      - makeはコマンドの実行前にそのコマンドをターミナルに出力する
      - その出力を抑えるには、コマンドの前に@をつける
      ```
      $(HOME)/.%: %
      	@echo $< $@
      ```
    MAKEFILE_FILE

    TEST_BASH_FILE_CONTENT = <<~BASH_FILE.freeze
      ---
      tags: ["bash", "documentation", "Tips"]
      ---
      ## bash: GNU Bourne-Again SHell

      ## ドキュメントの探し方
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
      ## 章だけを抜き出す
      man bash | perl -ne 'print if /^[A-Z]/'

      ## 章と節を抜き出す
      man bash | perl -ne 'print if /^[A-Z]|^\s{3}[A-Z]/'
      ```

      ## Tips
      Control + l(C-l)で画面にある出力を消去できる#{'  '}
      詳しくはman bashのCommands for Movingを参照#{'  '}
      その他、(M-f)と(M-b)で単語単位で前後に移動できる、など#{'  '}

      ### コマンドを例示するときのドル記号($)とハッシュ(#)の違い
      - $ -> 一般ユーザー
      - # -> rootユーザー

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
      ---
      tags: ["bash", "test", "status"]
      ---
      ## EXIT STATUS: CLIコマンドの終了ステータス

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

    TEST_HISTORY_EXPANSION_FILE_CONTENT = <<~HISTORY_EXPANSION_FILE
      ---
      tags: ["bash", "expansion"]
      ---
      ## HISTORY EXPANSION: コマンドの履歴を展開する
      - ドキュメント: HISTORY EXPANSIONという章がある
      ```
      man bash
      /HISTORY EXPANSION
      ```

      ## コマンドの再実行
      - 履歴展開 (History Expansion)
      1. 直前のコマンドを実行する
      ```bash
      $ !!
      ```

      2. インクリメンタルサーチ(Incremental search)
      - シェルプロンプトで`Ctrl - R`を押すと、コマンド履歴から逆順(Reverse)にインクリメンタル検索を実行できる

      3. 最近のstringで始まるコマンドを実行する
      ```bash
      $ !string
      ```

    HISTORY_EXPANSION_FILE

    TEST_FOR_FILE_CONTENT = <<~FOR_FILE
      ---
      tags: ["bash", "syntax", "documentation"]
      ---
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

    TEST_REDIRECTION_FILE_CONTENT = <<~REDIRECTION_FILE
      ---
      tags: ["bash", "Redirection", "I/O", "documentation"]
      ---
      ## Redirection: 標準出力と標準エラー出力の結果を表示しない場合
      - ドキュメント
      ```bash
      man bash
      /^REDIRECTION
      ```

      ### 出力を捨てるとき
      1. 標準出力だけ捨てる
      ```bash
      ls ~/Downloads/ > /dev/null
      ```

      2. 標準エラー出力だけ捨てる
      ```bash
      ls ~/Downloads/do-not-exist-file.txt 2> /dev/null
      echo $? # will return 1

      ## これは普通にlsの実行結果が表示される
      ls ~/Downloads/ 2> /dev/null
      ```

      3. 両方とも捨てる
      ```bash
      ## 従来の方法？
      command -v ls 2>&1 > /dev/null

      ## Bash 4.0だと次の書き方でもOKらしい
      command -v ls &> /dev/null
      ```
    REDIRECTION_FILE

    TEST_SPECIAL_PARAMETERS_FILE_CONTENT = <<~SPECIAL_PARAMETERS_FILE.freeze
      ---
      tags: ["bash", "Notation", "Tips", "documentation"]
      ---
      ## Special Parameters: $?, $!など
      ### ドキュメントの探し方
          - ?, !など、それぞれの記号ごとに、$を付けて展開したときの説明が載っている
      ```bash
      man bash
      /Special Parameters
      ```

      ### 概要
      - Special Parameterは$ を付けて展開する(Parameter Expansion)

      #### 変数の一覧
      - $#: スクリプトや関数に渡された引数の数
          - Ref: Expands to the number of positional parameters in decimal

      - $?: 直前に実行したコマンドの実行結果。0ならTrueである。
          - Ref: Expands to the status of the most recently executed foreground pipeline.

      - $!: 直前に実行したコマンドのプロセスID#{' '}
          - Ref: Expands to the process ID of the most recently executed background (asynchronous) command.
    SPECIAL_PARAMETERS_FILE

    TEST_COMMAND_HISTORY_FILE_CONTENT = <<~COMMAND_HISTORY_FILE
      ---
      tags: ["zsh", "documentation", "command history"]
      ---
      ## Zshのコマンド履歴について
          - fcコマンドを使う
          - コマンド履歴はtmuxだとウィンドウごとである

      ## ドキュメントの探し方
      ```zsh
      man zshbuiltins
      /fc
      ```

      ### Tips
      - /historyで検索すると、"Same as fc -l" と記載がある
          - zshではhistoryコマンドの代わりにfc -lコマンドを使う

      ## fcコマンドの例
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
      ---
      tags: ["TUI", "Tips"]
      ---
      ## Emacs: エディター
      ### 基本
      - メタキー: optionキーを使う
          - 例: M-v: 前の画面へスクロールする
              - optionキーとvキーを同時に押せばいい
      - 設定上の問題で、ghosttyではメタキーが無効になっている

      - Emacsを終了する
          - C-x C-c
      - コマンドを中断する
          - C-g

      ### 移動
          - (*Vim): Vimの設定ファイルで同様の設定にしているキーバインド
          - (!): 重要
      - 画面のスクロール
          - 次: C-v
          - 前: M-v
      - 段落単位でのの移動(!)
          - 次: M-a
          - 前: M-e
      - 行の移動
          - 次: C-n (*Vim)
          - 前: C-p (*Vim)
      - カーソルの移動
          - 次: C-f
          - 前: C-b
      - 単語単位でのの移動
          - 次: M-f
          - 前: M-b
      - 行頭、行末への移動
          - 行頭: C-a
          - 行末: C-e
      - ファイルの先頭と最後へ移動
          - 先頭: M-< (option + shift + ,)
          - 最後: M-> (option + shift + .)

      ### 移動２
      - カーソルをウィンドウの一番上に移動させる
          - C-u 0 C-l
          - vimだと本来はHで同様の動作ができる
              - Hは行頭へ移動するように変更している

      ## コマンド操作
      - Undo:
          - C-x u
          - C-_ (CTRL + Shift +「ろ」)
          - C-/(効かない！)

      ## 文字列検索
          - C-s (Tmuxのメタキーに設定していて効かない！)

      ## ウィンドウの操作
      - ウィンドウを一つにする: C-x 1

      ## 挿入・削除
      - 挿入はカーソルを移動させて文字を入力すればいい
      - 一文字ずつ削除
          - DEL: 後
          - C-d: 前


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
      ---
      tags: ["TUI", "Terminal", "git"]
      ---
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
      ---
      tags: ["TUI", "Terminal"]
      ---
      ## tmux: Terminal Multiplexer
      ### 例
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

    TEST_SET_THE_TABLE_FILE_CONTENT = <<~SET_THE_TABLE_FILE
      ---
      tags: ["テスト駆動開発", "AAA"]
      ---
      ## 前準備: 第18章から
      - テストの基本パターン: AAA(Bill Wakeによる命名)
          1. Arrange: 準備
          2. Act: 実行
          3. Assert: アサート

      - Arrangeは重複するコードが多いが、Act, Assertは重複しない場合が多い
          - そこで、setUpメソッドを利用して、テストごとにオブジェクトを作り直す
          - 各テストごとは独立であるべきで、テスト間ごとに依存関係を作ってはならない

    SET_THE_TABLE_FILE

    TEST_CHAT_FILE_CONTENT = <<~CHAT_FILE
      ---
      tags: ["English", "Messages"]
      ---
      ## Chat: 英語でチャットするとき
      ### 読み書きの能力を示す
      1. It's no problem for you to write a review in English
      2. I have a basic command of reading and writing in English.
    CHAT_FILE

    TEST_PROMPT_AI_FILE_CONTENT = <<~PROMPT_AI_FILE
      ---
      tags: ["English", "AI prompt"]
      ---
      ## Prompt AI: AIとの対話用
      ### 修正依頼
          - エラーがあれば直してほしい
      1. Please fix any errors. -> 少し丁寧
      2. Fix any errors if found. -> 自然

      ### 出力して欲しい・AIが読みやすい形で
          - AIが読みやすいようにpbcopyに渡して
      - Please pipe the output to pbcopy in an AI-readable format.
    PROMPT_AI_FILE

    TEST_VOCABULARY_ABOUT_COMPUTER_FILE_CONTENT = <<~VOCABULARY_ABOUT_COMPUTER_FILE
      ---
      tags: ["English", "Vocabulary"]
      ---
      ## Vocabulary about computer: 計算機科学に関する英単語
      - Instance: 例、実例
          - プログラミングだと具体的なオブジェクトのことをいう

    VOCABULARY_ABOUT_COMPUTER_FILE

    TEST_RUIGO_FILE_CONTENT = <<~RUIGO_FILE
      ---
      tags: ["日本語"]
      ---
      ## 類義: ある言葉について、その言葉と近い意味を持つ言葉のメモ帳
      - 儚い
          - 空しい
    RUIGO_FILE

    TEST_LS_FILE_CONTENT = <<~LS_FILE
      ---
      tags: ["bash", "CLI", "File and Directory", "表示"]
      ---
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

    TEST_MEMO_DATA_SEED = [
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/third-party',
        basename: 'mise',
        content: TEST_CLI_THIRD_PARTY_MISE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'setting',
        basename: 'mise',
        content: TEST_SETTING_MISE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'memo',
        basename: 'ANSI-escape-code-and-set-color',
        content: TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/builtin',
        basename: 'alias',
        content: TEST_ALIAS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/builtin',
        basename: 'command',
        content: TEST_COMMAND_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/file',
        basename: 'chmod',
        content: TEST_CHMOD_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/file',
        basename: 'realpath',
        content: TEST_REALPATH_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/process',
        basename: 'kill',
        content: TEST_KILL_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/process',
        basename: 'ps',
        content: TEST_PS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/search',
        basename: 'grep',
        content: TEST_GREP_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/text',
        basename: 'diff',
        content: TEST_CLI_CORE_TEXT_DIFF_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/text',
        basename: 'nl',
        content: TEST_NL_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/text',
        basename: 'sed',
        content: TEST_SED_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/text',
        basename: 'tr',
        content: TEST_TR_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/text',
        basename: 'wc',
        content: TEST_WC_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli',
        basename: 'ifconfig',
        content: TEST_IFCONFIG_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli',
        basename: 'tcpdump',
        content: TEST_TCPDUMP_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/third-party',
        basename: 'claude',
        content: TEST_CLAUDE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/third-party',
        basename: 'gh',
        content: TEST_GH_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/third-party',
        basename: 'nkf',
        content: TEST_NKF_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli',
        basename: 'units',
        content: TEST_UNITS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'branch',
        content: TEST_BRANCH_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'config',
        content: TEST_CONFIG_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'diff',
        content: TEST_GIT_DIFF_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'gitignore',
        content: TEST_GITIGNORE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'merge',
        content: TEST_MERGE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'pull',
        content: TEST_PULL_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'rebase',
        content: TEST_REBASE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'restore',
        content: TEST_RESTORE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'git',
        basename: 'switch',
        content: TEST_SWITCH_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'memo',
        basename: 'gitlab',
        content: TEST_GITLAB_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'how-to',
        basename: 'directory',
        content: TEST_DIRECTORY_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'how-to',
        basename: 'server',
        content: TEST_SERVER_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/awk',
        basename: 'awk',
        content: TEST_AWK_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/javascript',
        basename: 'array',
        content: TEST_LANG_JAVASCRIPT_ARRAY_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/javascript',
        basename: 'jsdoc',
        content: TEST_JSDOC_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/javascript',
        basename: 'npm',
        content: TEST_NPM_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/javascript',
        basename: 'pnpm',
        content: TEST_PNPM_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang',
        basename: 'naming-convention',
        content: TEST_NAMING_CONVENTION_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/python',
        basename: 'uv',
        content: TEST_UV_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'array',
        content: TEST_LANG_RUBY_ARRAY_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'bundle',
        content: TEST_BUNDLE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'compare',
        content: TEST_COMPARE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'minitest',
        content: TEST_MINITEST_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'print',
        content: TEST_PRINT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'ruby',
        content: TEST_RUBY_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'struct',
        content: TEST_STRUCT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'lang/ruby',
        basename: 'yard',
        content: TEST_YARD_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'meta',
        basename: 'format',
        content: TEST_FORMAT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim',
        basename: 'buffer',
        content: TEST_BUFFER_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim',
        basename: 'commenting',
        content: TEST_COMMENTING_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim/plugin',
        basename: 'neo-tree',
        content: TEST_NEO_TREE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim/plugin',
        basename: 'nvim-surround',
        content: TEST_NVIM_SURROUND_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim',
        basename: 'read-help',
        content: TEST_READ_HELP_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim',
        basename: 'script',
        content: TEST_SCRIPT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'neovim',
        basename: 'tips',
        content: TEST_TIPS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'memo',
        basename: 'react',
        content: TEST_REACT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'setting',
        basename: 'dockerfile',
        content: TEST_DOCKERFILE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'setting',
        basename: 'makefile',
        content: TEST_MAKEFILE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/bash',
        basename: 'bash',
        content: TEST_BASH_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/bash',
        basename: 'exit-status',
        content: TEST_EXIT_STATUS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/bash/expansion',
        basename: 'history-expansion',
        content: TEST_HISTORY_EXPANSION_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/bash',
        basename: 'for',
        content: TEST_FOR_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/bash',
        basename: 'redirection',
        content: TEST_REDIRECTION_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/bash',
        basename: 'special-parameters',
        content: TEST_SPECIAL_PARAMETERS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'shell/zsh',
        basename: 'command-history',
        content: TEST_COMMAND_HISTORY_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'tui',
        basename: 'emacs',
        content: TEST_EMACS_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'tui',
        basename: 'lazygit',
        content: TEST_LAZYGIT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'tui',
        basename: 'tmux',
        content: TEST_TMUX_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/private-memo/memo/',
        parent_dir: 'books/tdd',
        basename: 'set-the-table',
        content: TEST_SET_THE_TABLE_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/private-memo/memo/',
        parent_dir: 'english',
        basename: 'chat',
        content: TEST_CHAT_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/private-memo/memo/',
        parent_dir: 'english',
        basename: 'prompt-ai',
        content: TEST_PROMPT_AI_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/private-memo/memo/',
        parent_dir: 'english',
        basename: 'vocabulary-about-computer',
        content: TEST_VOCABULARY_ABOUT_COMPUTER_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/private-memo/memo/',
        parent_dir: 'japanese',
        basename: 'ruigo',
        content: TEST_RUIGO_FILE_CONTENT
      },
      {
        target_dir: '/Users/hy/repo/memorandum/memo/',
        parent_dir: 'cli/core/file',
        basename: 'ls',
        content: TEST_LS_FILE_CONTENT
      }
    ].freeze
  end
end
