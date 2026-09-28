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
    SETTING_MISE_FILE

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
      tags: ["bash", "CLI", "File and Directory", "display"]
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
      tags: ["bash", "CLI", "File and Directory", "display"]
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
      tags: ["bash", "CLI", "process", "display", "tally"]
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

    TEST_DIFF_FILE_CONTENT = <<~DIFF_FILE
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
    DIFF_FILE

    TEST_NL_FILE_CONTENT = <<~NL_FILE
      ---
      tags: ["bash", "CLI", "text", "display", "count"]
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
      tags: ["bash", "CLI", "text", "display", "count"]
      ---
      ## オプション
      出力される数値は、行数・単語数・バイト数の順番で並んでいる#{'  '}

      - -l: 行数のみ出力
      - -c: バイト数のみ出力
      - -m: 文字数でカウント。通常はUTF-8で数える。日本語も一文字としてカウント
      - -w: 単語数のみ出力。日本語だと使う意味がそこまでない。
    WC_FILE

    TEST_IFCONFIG_FILE_CONTENT = <<~IFCONFIG_FILE
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
      tags: ["CLI", "External Command", "text", "display", "Character Inspection", "edit"]
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
      - units: 単位の計算ができる
          - mac版だと'/usr/share/misc/units.lib'に使える単位の一覧がある
    UNITS_FILE

    TEST_APPLY_FILE_CONTENT = <<~APPLY_FILE
      ---
      tags: ["CLI", "git", "Email", "Patching"]
      ---
      - パッチファイルを適用する
      ```bash
      git apply <filename>

      # 例
      git apply patch.diff
      ```

      - patchコマンドでも差分を取り込めるらしい
    APPLY_FILE

    TEST_COMMIT_FILE_CONTENT = <<~COMMIT_FILE
      ---
      tags: ["CLI", "git", "Basic Snapshotting"]
      ---
      ## commit: コードの変更をコミットする

      ## 例
      ```bash
      ## --amendを使うと、ステージ済みの変更を直前のコミットに統合できる
      git commit --amend

      ## メッセージの変更が不要な場合
      git commit --amend --no-edit
      ```
    COMMIT_FILE

    TEST_CONFLICT_FILE_CONTENT = <<~CONFLICT_FILE
      ---
      tags: ["CLI", "git", "Conflict"]
      ---
      - fix conflict
      ```bash
      $ vimdiff  # alias vimdiff="git mergetool -t vimdiff"
      ```

      - マージしてきた方のブランチにコードを合わせる場合
      ```bash
      # マージしてきた方のブランチを採用する
      # 注意: file に. を指定すると、マージしてきた方のブランチを全て採用してしまう。
      # file は個別に指定すること
      git restore --theirs <file>

      # または、次のコマンドで取り込む
      # --staged と --worktree の両方を指定してgit add <file> と同様の動作をする
      git restore --source=MERGE_HEAD --staged --worktree <file>

      # 現在のブランチ(HEAD)の方を採用する
      git restore --ours <file>
      ```

      - 特殊なHEADリファレンス
          - `HEAD`: 現在チェックアウトしているコミット
          - `MERGE_HEAD`: マージ中の相手ブランチの先頭コミット
          - `ORIG_HEAD`: merge/rebase/reset実行前のHEADの位置
          - `FETCH_HEAD`	直前のgit fetchで取得したリモートの先頭
          - `CHERRY_PICK_HEAD`: cherry-pick中の対象コミット
          - `REBASE_HEAD`: rebase中に現在適用しているコミット

      - コンフリクトマーカーの見方
      ```diff
      <<<<<<< HEAD
      現在のブランチの内容（ours / stage 2）
      ||||||| abc1234  ← diff3 スタイルの場合のみ表示
      共通祖先の内容（base / stage 1）
      =======
      マージしてくるブランチの内容（theirs / stage 3）
      >>>>>>> feature-branch
      ```

      - diff3スタイルを有効にする
      ```bash
      git config --global merge.conflictstyle diff3
      ```
    CONFLICT_FILE

    TEST_GIT_FILE_CONTENT = <<~GIT_FILE
      ---
      tags: ["CLI", "git", "documentation"]
      ---
      - git
      ## ドキュメント
      https://git-scm.com/about
          - git用のTUIなどの一覧が載っている
    GIT_FILE

    TEST_LOG_FILE_CONTENT = <<~LOG_FILE
      ---
      tags: ["CLI", "git", "Branching and Merging", "Inspection Version"]
      ---
      - 基本的なログ表示
      ```bash
      git log --oneline
      ```

      - ブランチの分岐を視覚的に表示
      ```bash
      git log --graph --oneline --all
      ```

      - 特定のファイルの変更履歴
      ```bash
      git log --follow -- filename
      ```

      - developにはない現在のブランチのみのコミットを表示する
      ```bash
      git log develop..HEAD

      # -p で差分も確認できる
      git log -p develop..HEAD

      # ここからmergeコミットを取り除くには
      git log --no-merges develop..HEAD

      # tig でも同様
      tig -p --no-merges develop..HEAD
      ```
    LOG_FILE

    TEST_CHECKOUT_FILE_CONTENT = <<~CHECKOUT_FILE
      ---
      tags: ["CLI", "git", "Branching and Merging", "legacy"]
      ---
      ## git checkout: git restore + git switchの機能があるgit CLI
      ## `git checkout`から`git switch`, `git restore`へ
      - `git checkout`の役割
          - ブランチの切り替え
          - 新規ブランチの作成
          - ファイルの復元
          - コミットのチェックアウト

          -> これらを`git switch`か`git restore`へ
    CHECKOUT_FILE

    TEST_PUSH_FILE_CONTENT = <<~PUSH_FILE
      ---
      tags: ["CLI", "git", "Sharing and Updating Projects"]
      ---
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
      ---
      tags: ["CLI", "git", "Basic Snapshotting"]
      ---
      ## git reset
      - resetとrevertの違い
          - reset -> コミットログが残らない
          - revert -> コミットログが残る

      - featureブランチで直前のコミットを取り消す
      ```bash
      git reset --soft HEAD^
      ```
    RESET_FILE

    TEST_REV_PARSE_FILE_CONTENT = <<~REV_PARSE_FILE
      ---
      tags: ["CLI", "git", "Plumbing Commands"]
      ---
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
      ---
      tags: ["git", "Sharing and Updating Projects", "Branching and Merging", "Option"]
      ---
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
      ---
      tags: ["JavaScript", "Debug", "I/O"]
      ---
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
      ---
      tags: ["JavaScript", "Hash", "Data Structure", "Notation"]
      ---
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
      ---
      tags: ["JavaScript", "Package Manager", "Setting"]
      ---
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
      ---
      tags: ["lua", "Package Manager", "Linter", "Setting", "Formatter"]
      ---
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

      - 実行
      ```bash
      luacheck config/nvim/**/*.lua
      ```
    LUA_FILE

    TEST_ONELINER_FILE_CONTENT = <<~ONELINER_FILE
      ---
      tags: ["perl", "oneliner", "display", "edit", "substitute", "regex"]
      ---
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

    TEST_ARRAY_FILE_CONTENT = <<~ARRAY_FILE
      ---
      tags: ["ruby", "array", "Creation", "Concatenation", "Data Structure"]
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
    ARRAY_FILE

    TEST_CLASS_FILE_CONTENT = <<~CLASS_FILE
      ## Rubyとクラス
      - 用語整理のためにメモを作成

      ## 用語集
      - クラス
      クラスが仕様でオブジェクトなどが実装という理解

      - オブジェクト、インスタンス、レシーバ
          - どれもクラスから作成される実装の方をさすという理解
          - オブジェクトだと意味の範囲が広くなってしまう
          - インスタンスがちょうどいい
          - レシーバは呼び出し、受け取りの文脈で使われるのだろう

      - メソッド、メッセージ
          - オブジェクトの振る舞いのことをさす
          - ざっくり関数だが、さらに広く手続きとも言えるし...
          - 他、メッセージというのも使う。先述のレシーバと組み合わせて使うのだろうか？

      - 属性、アトリビュート、プロパティ
          - オブジェクトに設定あるいは取得できる値のこと

      - インスタンスメソッド
          - 次のようなよく使うメソッドのこと
          - インスタンスメソッドからクラスメソッドを呼び出す場合の例も記載した
      ```ruby
      class Klass
        # クラス変数: クラスメソッドからでも参照できる変数
        # ライブラリの設定情報を入れる場合などに使う。あまり使わない。
        @@config = 'develop'

        def foo
          :foo
        end

        # インスタンスメソッドからクラスメソッドを呼び出す
        def call_class_method
          Klass.bar
        end

        def self.bar(baz)
           # クラスメソッドで@fooのように変数を定義した場合は、クラスインスタンス変数と呼ばれ、インスタンス変数と区別される
           @baz = baz
          :bar
        end

        ## クラスの入れ子はクラスの継承とは違う
        ## 名前空間を作る場合に使うが、モジュールを使う場合の方が多い
        class SubKlass
          def initialize(qux)
            @qux = qux
          end
        end
      end
      ```

      - インスタンス変数
          - `@foo`のこと

      - アクセサメソッド
          - ゲッター・セッターメソッドの総称
          - インスタンス変数を外部から読み書きできるようにするには、`attr_accessor <symbol>`を使う

      - クラスメソッド
          - `def self.foo`のこと
          - そのクラスのインスタンスのデータを使わないでメソッドを定義したい場合に使う

      - 定数
          - 大文字で書く

      - super
          - initializeにsuperと書くと、スーパークラスに引数を全て渡せる
          - また、super()と書くと、スーパークラスには引数が渡らない
    CLASS_FILE

    TEST_GEM_FILE_CONTENT = <<~GEM_FILE
      - gem
          - Rubyのパッケージマネージャー
          - プロジェクトごとにパッケージを管理する場合はbundleを使う

      - 例
      ```bash
      # RubyGems のリポジトリを調べる
      gem search -r <package>

      ## 例: pryに関係のあるパッケージを調べる
      gem search -r pry

      # gem のサブコマンド一覧を表示する
      gem help commands

      # gem list のhelp を確認する
      gem help list
      ```

      ## Gemfileのバージョン指定
      ```ruby
      ## バージョンを固定する場合
      gem "minitest", "6.0.6"

      ## 指定したバージョン以上を使う
      gem "minitest", ">= 6.0.6"

      ## 6.0.6から6.1.0未満までを使う(悲観的なバージョン指定)
      ## バージョンの桁数によって指定する範囲が変わる
      gem "minitest", "~> 6.0.6"

      ## これなら6.0以上7.0未満となる
      gem "minitest", "~> 6.0"
      ```

      - 自分でインストールしたgemの一覧
          - (1)インストール先を指定して確認するコマンドや、(2)インストール場所ごとに分けて確認するコマンドを組み合わせて確認する。
          1. `gem list -d`
          2. `gem environment`
    GEM_FILE

    TEST_MODULE_FILE_CONTENT = <<~MODULE_FILE
      ## Rubyとモジュール
      - TODO: クラスのときのように一通りまとめてみること

      ## Module#module_function
      - メソッドをモジュール関数にする
      - モジュール関数とは、プライベートメソッドかつモジュールの特異メソッドであるメソッドのことをいう
          - メモ
              - モジュール内にインスタンスメソッドを定義した場合、includeはできるが、FooModule.bar_methodのようなメソッドの指定ができない
              - そのため、モジュールをincludeせずに直接指定してモジュールを利用するには特異メソッドにする必要がある
              - そこでこのmodule_functionを使う


    MODULE_FILE

    TEST_RUBY_FILE_CONTENT = <<~RUBY_FILE
      ## Ruby
      - manコマンドでCLIのrubyコマンドの使い方を見ることができる
          - テストで何が行われているかとか、ワンライナーの書き方とかで参考になるかも
      ```bash
      man ruby
      ```

      - memoに書いておきたいこと
          - Rubyのエコシステムやツールのこと
          - Rubyのテスト・デバッグに関するツールのこと
          - その他、忘れやすい文法など

      - HashとData, Structについて
      1. Hashの値は数値、文字列、シンボルなどが良く、配列あたりのオブジェクトは望ましくないらしい
      2. それ以上、複雑なデータ構造を作成するならDataやStructを使う
      3. でも、その中間のようなデータ構造はあるよなあ...
    RUBY_FILE

    TEST_STRING_FILE_CONTENT = <<~STRING_FILE
      ---
      tags: ["ruby", "string", "Creation", "Concatenation", "Data Structure"]
      ---
      # String: 文字列クラスについて

      ## 文字列の結合
      - `+, <<, concat`について、
          - <<, concatは破壊的変更である
              - サイズの大きいデータを生成するときなどに使う
              - `# frozen_string_literal: true`が指定されていると使えない

          1. <<: 文字列を破壊的に連結する
              ```ruby
              str = "foo"
              # => "foo"
              str << "bar"
              # => "foobar"
              ```

          2. concat: 複数の文字列を破壊的に連結する
              ```ruby
              str = "foo"
              # => "foo"
              str.concat "bar", "baz"
              # => "foobarbaz"
              str
              # => "foobarbaz"
              ```

          3. +: 元の文字列からその複製を返す
              - 文字列がfrozenされていても使える
              - パフォーマンスが悪くなるので、サイズの大きい文字列の生成をする際には注意すること

    STRING_FILE

    TEST_YARD_FILE_CONTENT = <<~YARD_FILE
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

    TEST_MARKDOWN_FILE_CONTENT = <<~MARKDOWN_FILE
      - markdown: markdownの記法に関するメモ
      # 特殊文字(Special Characters)
      ## バックスラッシュ(\\)
      <kbd>option</kbd> + <kbd>¥</kbd>

      - Front Matter
          - Markdownファイルの先頭に記載されるメタデータのこと

      - textlint
      ```bash
      # textlintと日本語のスペース関連のプリセットをグローバルにインストール
      pnpm add -g textlint textlint-rule-preset-ja-spacing

      # ファイル名は必ず引用符で括る必要がある(自分の環境だけ？)
      textlint --preset preset-ja-spacing "README.md"
      ```
    MARKDOWN_FILE

    TEST_BUFFER_FILE_CONTENT = <<~BUFFER_FILE
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
      tags: ["neovim", "TUI"]
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
      nvim -u script.lua <file_name>

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
      - tips
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
      - React: フロントエンドライブラリ・UIフレームワーク

      ## Container / Presentational Component
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
      - Makefile: タスクランナーとファイル操作
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

    TEST_LS_FILE_CONTENT = <<~LS_FILE
      ---
      tags: ["bash", "CLI", "File and Directory", "display"]
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
        parent_dir: "cli/third-party",
        basename: "mise",
        content: TEST_CLI_THIRD_PARTY_MISE_FILE_CONTENT
      },
      {
        parent_dir: "setting",
        basename: "mise",
        content: TEST_SETTING_MISE_FILE_CONTENT
      },
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
        basename: "command",
        content: TEST_COMMAND_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/file",
        basename: "chmod",
        content: TEST_CHMOD_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/file",
        basename: "realpath",
        content: TEST_REALPATH_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/process",
        basename: "kill",
        content: TEST_KILL_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/process",
        basename: "ps",
        content: TEST_PS_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/search",
        basename: "grep",
        content: TEST_GREP_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "diff",
        content: TEST_DIFF_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "nl",
        content: TEST_NL_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "sed",
        content: TEST_SED_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "tr",
        content: TEST_TR_FILE_CONTENT
      },
      {
        parent_dir: "cli/core/text",
        basename: "wc",
        content: TEST_WC_FILE_CONTENT
      },
      {
        parent_dir: "cli",
        basename: "ifconfig",
        content: TEST_IFCONFIG_FILE_CONTENT
      },
      {
        parent_dir: "cli",
        basename: "tcpdump",
        content: TEST_TCPDUMP_FILE_CONTENT
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
        basename: "commit",
        content: TEST_COMMIT_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "conflict",
        content: TEST_CONFLICT_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "git",
        content: TEST_GIT_FILE_CONTENT
      },
      {
        parent_dir: "git",
        basename: "log",
        content: TEST_LOG_FILE_CONTENT
      },
      {
        parent_dir: "git/old",
        basename: "checkout",
        content: TEST_CHECKOUT_FILE_CONTENT
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
        basename: "array",
        content: TEST_ARRAY_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "class",
        content: TEST_CLASS_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "gem",
        content: TEST_GEM_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "module",
        content: TEST_MODULE_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "ruby",
        content: TEST_RUBY_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "string",
        content: TEST_STRING_FILE_CONTENT
      },
      {
        parent_dir: "lang/ruby",
        basename: "yard",
        content: TEST_YARD_FILE_CONTENT
      },
      {
        parent_dir: "memo",
        basename: "markdown",
        content: TEST_MARKDOWN_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "buffer",
        content: TEST_BUFFER_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "commenting",
        content: TEST_COMMENTING_FILE_CONTENT
      },
      {
        parent_dir: "neovim/plugin",
        basename: "neo-tree",
        content: TEST_NEO_TREE_FILE_CONTENT
      },
      {
        parent_dir: "neovim/plugin",
        basename: "nvim-surround",
        content: TEST_NVIM_SURROUND_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "read-help",
        content: TEST_READ_HELP_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "script",
        content: TEST_SCRIPT_FILE_CONTENT
      },
      {
        parent_dir: "neovim",
        basename: "tips",
        content: TEST_TIPS_FILE_CONTENT
      },
      {
        parent_dir: "memo",
        basename: "react",
        content: TEST_REACT_FILE_CONTENT
      },
      {
        parent_dir: "setting",
        basename: "dockerfile",
        content: TEST_DOCKERFILE_FILE_CONTENT
      },
      {
        parent_dir: "setting",
        basename: "makefile",
        content: TEST_MAKEFILE_FILE_CONTENT
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
        parent_dir: "shell/bash/expansion",
        basename: "history-expansion",
        content: TEST_HISTORY_EXPANSION_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "for",
        content: TEST_FOR_FILE_CONTENT
      },
      {
        parent_dir: "shell/bash",
        basename: "redirection",
        content: TEST_REDIRECTION_FILE_CONTENT
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
      },
      {
        parent_dir: "cli/core/file",
        basename: "ls",
        content: TEST_LS_FILE_CONTENT
      }
    ].freeze
  end
end
