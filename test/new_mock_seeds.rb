# frozen_string_literal: true

module Memo
  module MockSeed
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

    TEST_CHROME_FILE_CONTENT = <<~CHROME_FILE
      ---
      tags: ["Browser", "Frontend"]
      ---
      ## Chrome

      - 開発コンソールのコマンドパレッドの出し方
          - スクリーンショットを撮るときに使う
          `Cmd + Shift + P`
    CHROME_FILE

    TEST_BUILTIN_FILE_CONTENT = <<~BUILTIN_FILE
      ---
      tags: ["bash", "CLI", "builtin", "Command inspection"]
      ---
      ## builtin: そのコマンドがbuiltinかどうかを判別する
      - 組み込みだと正常終了し、何も帰ってこない
      - それ以外だと何かが帰ってくる
      - cdがカスタマイズされてないかどうかを調べたりするのに使うらしい
    BUILTIN_FILE

    TEST_HASH_FILE_CONTENT = <<~HASH_FILE
      ---
      tags: ["bash", "CLI", "builtin", "Command inspection"]
      ---
      ## hash: bash builtinコマンド
      - その環境で実行できるコマンドと、そのコマンドのパスの一覧が確認できる
      ```bash
      hash | wc -l
      # > 2692

      hash | grep "^ls"
      # > ls=/bin/ls
      # > ...
      # > ...
      ```
    HASH_FILE

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

    TEST_GROUPS_FILE_CONTENT = <<~GROUPS_FILE
      ---
      tags: ["bash", "CLI", "legacy"]
      ---
      ## groups: グループを表示する
      - idコマンドにより廃止された
      - `id -Gn [user]`と同等である
    GROUPS_FILE

    TEST_LSOF_FILE_CONTENT = <<~LSOF_FILE
      ---
      tags: ["bash", "CLI", "process", "terminate"]
      ---
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
      ---
      tags: ["bash", "CLI", "search", "bulk", "pipe", "recursive"]
      ---
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
      ---
      tags: ["bash", "CLI", "text", "filter", "remove"]
      ---
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

    TEST_CLI_CORE_TEXT__FILE_CONTENT = <<~CLI_CORE_TEXT__FILE
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
    CLI_CORE_TEXT__FILE

    TEST_ED_FILE_CONTENT = <<~ED_FILE
      ---
      tags: ["bash", "CLI", "text", "legacy"]
      ---
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

    TEST_REV_FILE_CONTENT = <<~REV_FILE
      ---
      tags: ["bash", "CLI", "text", "reverse"]
      ---
      ## rev: 文字列を逆順にして表示する

      ### 例
      ```bash
      cat foo << EOF
      abc
      def
      ghi
      EOF

      rev foo
      # > cba
      # > fed
      # > ihg
      ```

      - tacも参照すること
    REV_FILE

    TEST_TAC_FILE_CONTENT = <<~TAC_FILE
      ---
      tags: ["bash", "CLI", "text", "reverse"]
      ---
      ## rev: ファイルを連結させて最後の行から表示する

      ### 例
      ```bash
      cat foo << EOF
      abc
      def
      ghi
      EOF

      tac foo
      # > ghi
      # > def
      # > abc
      ```

      - revも参照すること
    TAC_FILE

    TEST_UNIQ_FILE_CONTENT = <<~UNIQ_FILE
      ---
      tags: ["bash", "CLI", "text", "set", "edit", "filter", "remove", "集計"]
      ---
      - uniq: 文字の重複排除
          - 他のコマンドとsortと組み合わせて使うことが多い
      ```bash
      # 例: コマンド履歴の集計
      fc -ln 1 | sort | uniq -c | sort
      ```
    UNIQ_FILE

    TEST_XARGS_FILE_CONTENT = <<~XARGS_FILE.freeze
      ---
      tags: ["bash", "CLI", "text", "bulk", "edit", "pipe", "search", "集計"]
      ---
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

      - カレントディレクトリ配下のファイルについて、ファイル名を取得する
      ```bash
      find . -type f | fzf | xargs -n1 basename
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

      ## パケット回数を10回に制限して、その内容をASCII文字で出力する
      tcpdump -i en0 -c 10 -A

      ## 使用できるインターフェイスの一覧
      tcpdump -D

      ## アプリケーションのサービス名で絞り込む
      tcpdump -i en0 port https
      ### dnsは"domain"と指定する
      tcpdump -i en0 port domain
      ## ホスト名でなくポート番号で指定するな-nnを指定する
      tcpdump -i en0 port -nn 443
      ```

      ## ポート番号とサービス名の定義ファイル
      - `/etc/services`を確認すること
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

    TEST_MISE_FILE_CONTENT = <<~MISE_FILE
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
    MISE_FILE

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

    TEST_SQLITE3_FILE_CONTENT = <<~SQLITE3_FILE
      ## sqlite3: sqlite3 CLIの使い方など
      ### 使い方
      ```bash
      ## DBを読み込む
      sqlite3 test.db
      ```

      ### 例
      ```
      -- テーブルの一覧を表示する
      .table

      -- テーブルのスキーマを確認する
      .schema <table_name>

      -- 結果をHTMLにしてブラウザで表示する
          - .wwwの後にEnterを押して、その後にSQLを実行するとブラウザが起動して結果がテーブルで確認できる
      .www
      ```
    SQLITE3_FILE

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

    TEST_GIT__FILE_CONTENT = <<~GIT__FILE
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
    GIT__FILE

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
          - ファイル名の変更があっても、その前のコミットログまで追うことができる
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
      ---
      tags: ["How to", "Network"]
      ---
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

    TEST_RANDOM_FILE_CONTENT = <<~RANDOM_FILE
      ---
      tags: ["How to", "Generator"]
      ---
      ## Random: 乱数やランダムな文字列の表示方法
      ```bash
      ## 1から100までの数が4カラムで表示される
      jot -r 100 | rs 25
      ```
    RANDOM_FILE

    TEST_SPECIAL_CHARACTERS_FILE_CONTENT = <<~SPECIAL_CHARACTERS_FILE
      ---
      tags: ["How to", "Characters", "Keyboard"]
      ---
      ## 特殊文字(Special Characters)
      - 特殊文字とその文字の打ち方について

      ### バックスラッシュ(\\)
      - M + ¥
          - <kbd>option</kbd> + <kbd>¥</kbd>
    SPECIAL_CHARACTERS_FILE

    TEST_HOVER_FILE_CONTENT = <<~HOVER_FILE
      ---
      tags: ["CSS", "擬似クラス"]
      ---
      ## hover: CSSの擬似クラス(pseudo-classes)
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
      tags: ["JavaScript", "連想配列", "データ構造", "Notation"]
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
      tags: ["perl", "oneliner", "表示", "edit", "substitute", "regex"]
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

    TEST_ARGUMENTS_FILE_CONTENT = <<~ARGUMENTS_FILE
      ---
      tags: ["Ruby", "引数", "TODO"]
      ---
      ## Arguments: Rubyの引数の取り扱いについて
      - キーワード引数
      ```ruby
      ### 出典: https://www.ruby-lang.org/ja/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/#what-is-deprecated
      ## キーワード引数を渡したい場合は次の形式にすべき
      foo(k: expr)
      foo(**expr)

      ## キーワード引数を受け取りたい場合は次の形式にすべき
      def foo(k: default)
      def foo(k:)
      def foo(**kwargs)
      ```
    ARGUMENTS_FILE

    TEST_ASSIGNMENT_FILE_CONTENT = <<~ASSIGNMENT_FILE.freeze
      ---
      tags: ["Ruby", "配列", "演算子式", "初期化"]
      ---
      ## assignment: Rubyの代入式
      - 参照(api-docs): https://docs.ruby-lang.org/en/master/syntax/assignment_rdoc.html#abbreviated-assignment

      ### 初期化子
      ```ruby
      # a が偽か未定義ならば1を代入。
      a ||= 1#{'         '}
      ```
    ASSIGNMENT_FILE

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

    TEST_INDEX_FILE_CONTENT = <<~INDEX_FILE
      ---
      tags: ["Ruby", "Idiom"]
      ---
      ## Index in Ruby: Rubyでのインデックスの取り扱い
          - 取り扱いによく迷うので

      ### 方針
      #### each_with_index => with_indexを使う
      - rubocopで修正される
      - with_indexは引数をとって、その引数から数え始めることができる(offset argument)

      ### 例
      ```ruby
      str_arr = ['foo', 'bar', 'baz']

      ## インデックスの開始を１に定めた場合
      str_arr.map.with_index(1) do |s, i|
        p s, i
      end
      # => "foo", 1, "bar", 2, ...
      ```

      ### injectと同時に使用する場合
      - resultか真ん中のオブジェクトに割り当てられる値が何かバグったから違う方法で書いた方がいいかも
          - 書くとしたら`[1, 2, ...].map.with_index.inject(0) { |result, (item, index)| ... }`とする
    INDEX_FILE

    TEST_MODULE_FILE_CONTENT = <<~MODULE_FILE
      ---
      tags: ["Ruby", "TODO"]
      ---
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

    TEST_RAKE_FILE_CONTENT = <<~RAKE_FILE
      ---
      tags: ["Ruby", "Task Runner"]
      ---
      - rake: タスクランナー
      ```bash
      # タスクの一覧を表示する
      rake -T
      ```
    RAKE_FILE

    TEST_STRING_FILE_CONTENT = <<~STRING_FILE
      ---
      tags: ["Ruby", "string", "Creation", "Concatenation", "データ構造"]
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

    TEST_TYPE_CHECK_FILE_CONTENT = <<~TYPE_CHECK_FILE
      ---
      tags: ["Ruby", "型検査"]
      ---
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
      ---
      tags: ["テストコード"]
      ---
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

    TEST_NULL_FILE_CONTENT = <<~NULL_FILE
      ## null: 存在しない・無効であることを示す
      ### 定義
          - ref: https://developer.mozilla.org/ja/docs/Glossary/Null
              > 存在しないまたは無効なオブジェクトやアドレスへの"ポインター参照"を表します。
          - ヌルポインタ: https://ja.wikipedia.org/wiki/%E3%83%8C%E3%83%AB%E3%83%9D%E3%82%A4%E3%83%B3%E3%82%BF
              > 何のオブジェクトも指していないことを表す特別なポインタの値

      ### nullの分類
      - nullには二つの分類がある
          1. 未知(unknown)
          2. 適用不能(Not Applicable, N/A)

      ### 言語別のnull
      - null: Java, JavaScript
      - nil: Ruby, Go, Pasca
      - None: Python
      - (undefined): JavaScript
          - ref: https://developer.mozilla.org/ja/docs/Glossary/Undefined
    NULL_FILE

    TEST_COMPILER_MEMO_FILE_CONTENT = <<~COMPILER_MEMO_FILE
      ---
      tags: ["コンパイラ"]
      ---
      ##  compiler-memo: 「コンパイラ」(Aho他) についてのメモ書きや演習問題
      Aho. p.55
      次の文法: S -> S S + | S S * | aについて
      a) この文法によって、記号列aa+a*がどのようにして生成されるか
      -)
      S
      -> S S *
      -> S a *
      -> S S + a *
      -> a a + a *

      b)
        S --> S -----> S -> a
           -> S -> a   S -> a
           -> *        +

      Aho. p.219
      文法S => (S)S | eについて、例えばSを(S)Sで置き換えることを、導出するといい、S => (S)Sで表す
      ex) S => (S)S => ((S)S)S => ((S)S)(S)S => ((S)(S)S)(S)S => (()())()

      Aho. p.222
      文脈自由文法: S => S S + | S S * | a
      記号列: aa+a*

      a) 最左導出とb) 最右導出
      ) S => S S * => S S + S * まで導出して
      a) => a S + S * => a a + S * => a a + a *

      これは違う: b) => S S + a * => S a + a * => a a + a *
      正解はb) S => S S * => S a * => S S + a * => S a + a * => a a + a *

      左再帰
      次のような文脈自由文法がある (p.207 - (4.1))
      E => E + T | T
      T => T * F | F
      F => ( E ) | id
      この文法は左再帰である。

      左再帰を含む生成規則A => Aa | bは次のような非左再帰の生成規則によって置き換えられる。
      a) A => Aa | b
      b) A => bR
         R => aR | e

      これを使って(4.1)を次のように書き換える(4.14)
      - 生成規則(Production Rule)
      E  => T E'
      E' => + T E' | e
      T  => F T'
      T' => * F T' | e
      F => ( E ) | id

      FIRST(E') = {+, e}
      FIRST(T') = {*, e}
      FIRST(F) = {(, id}
      FIRST(E) = FIRST(T) = FIRST(F) = {(, id}
      ## FIRST(E) -> FIRST(T E') -> FIRST(T)
      ## FIRST(T) -> FIRST(F T') -> FIRST(F)

      FOLLOW(E) = {), $}
      FOLLOW(T) = FOLLOW(T') = {+, ), $}
      FOLLOW(F) = {+, *, ), $}
    COMPILER_MEMO_FILE

    TEST_CHAPTER_3_FILE_CONTENT = <<~CHAPTER_3_FILE.freeze
      ---
      tags: ["Security", "HTTP"]
      ---
      # 第三章　Webセキュリティの基礎
      ## HTTP

      ### リクエストメッセージ
      ```
      ## 一行目はリクエストラインと呼ばれる
      ### メソッド URL プロトコルバージョン
      GET http://example.jp/31/31-001.php HTTP/1.1
      ## 二行目以降はヘッダと呼ばれる
      host: example.jp
      User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:129.0) Gecko/20100101 Firefox/129.0
      Referer: https://example.jp/31/
      ```

      ### レスポンスメッセージ
      ```
      ## ステータスライン
      ### プロトコルバージョン ステータスコード テキストフレーズ
      HTTP/1.1 200 OK
      ## ヘッダ
      ### 空行が現れるまでヘッダが続く
      Date: Thu, 29 Aug 2024 20:10:30 GMT
      ...
      ## 空行

      ## ボディ
      <body>
      5:10</body>
      ```

      ### POSTメソッドのリクエストメッセージ
      ```
      ## リクエストメッセージの抜粋
      POST http://example.jp/31/31-003.php HTTP/1.1
      Referer: https://example.jp/31/31-002.php
      Content-Type: application/x-www-form-urlencoded
      Content-Length: 63
      host: example.jp
      ## 空行

      ## ボディ
      name=%E6%A9%8B%E6%9C%AC&mail=aaa%40example.com&gender=%E7%94%B7
      ```


      ### hiddenパラメータのメリット
      - hiddenは利用者自身からは書き換えできるが、情報漏洩や第三者からの書き換えに関しては堅牢
      #{'    '}

      ### ステートレスなHTTP認証
      - HTTPには認証機能がサポートされている。これをHTTP認証と呼ぶ。
      - 実装方式により、Basic認証やNTLM認証、Digest認証などがある。
      - HTTPがステートレスなプロトコルであることから、HTTP認証もステートレスである。

      ### Basic認証
      - リクエストメッセージにAuthorizationヘッダを付与する。次の形式である。
          - 一度認証に成功すると、ブラウザが自動的にAuthorizationヘッダを付与する。
          - そのため、見かけ上は認証状態が保たれているように見えるが、実際にはリクエスト毎にIDとパスワードが送出されており、認証状態は保持されていない。
          - このようにBasic認証はステートレスなので、ログアウトという概念もない。
      ```
      Authorization: Basic encode(<username>:<password>)
      ```


      ## クッキーとセッション管理
      - HTTPはステートレスであるため、サーバー側では状態を保持しない。
      - しかし、アプリケーションでは状態を保持したい要求がある。このようにアプリケーションの状態を覚えておくことをセッション管理という。
      - このセッション管理をHTTPで実現するために、クッキーという仕組みが導入されている。

      ### サンプルアプリケーションの例
      - 最初のログイン画面を表示させると次のレスポンスが返ってくる。
      ```
      HTTP/1.1 200 OK
      Content-Length: 279
      Content-Type: text/html; charset=UTF-8
      ## Webサーバーからブラウザに対してクッキー値を覚えるよう命令
      Set-Cookie: PHPSESSID=8cc8e8cd9d99b775b22864e9b3650fc4
      ```

      - ログイン画面の「ログイン」ボタンをクリックすると、次のリクエストがブラウザからサーバーに送信される。
      ```
      POST http://example.jp/31/31-021.php HTTP/1.1
      host: example.jp
      Content-Type: application/x-www-form-urlencoded
      Content-Length: 22
      Referer: https://example.jp/31/31-020.php
      ## 同じサイト(example.jp)にリクエストを送信する際は、覚えたクッキー値を送信する。
      ## 有効期限が設定されていないクッキーは、ブラウザを終了させるまで有効。
      Cookie: PHPSESSID=8cc8e8cd9d99b775b22864e9b3650fc4
      ```

      ### セッションIDに求められる要件
      1. 第三者がセッションIDを推測できないこと
          - 開発ツールの提供するセッション管理機構を利用すること
      #{'    '}
      2. 第三者からセッションIDを強制されないこと
          - 認証後にセッションIDを変更すること
      #{'    '}
      3. 第三者にセッションIDが漏洩しないこと
          - クッキーのDomain属性は原則として設定しない
          - クッキーのHttpOnly属性は基本的に設定する

      ## 受動的攻撃と同一オリジンポリシー

      ### 受動的攻撃
      - Webサイトの利用者に罠を仕掛けるなどの攻撃手法。
          - ブラウザとWebサイトのそれぞれで対策を行う必要がある。

      ### ブラウザのセキュリティ機能 - サンドボックスという考え方
      - JavaScriptのサンドボックス
          - ローカルファイルへのアクセス禁止
          - プリンタなどの資源の利用禁止 (画面表示は可能)
          - ネットワークアクセスの制限 (同一オリジンポリシー)
      - 異なるホストのJavaScriptからのアクセスは拒否される。
      #{'    '}
      #### 同一オリジンである条件
      - URLのホストが一致している
      - スキーム(プロトコル)が一致している
      - ポート番号が一致している

      ### JavaScript以外のクロスドメインアクセス
      - frame要素とiframe要素
          - iframe(frame)要素はクロスドメインのアクセスができる。
      #{'    '}
      - img要素
          - img要素のsrc属性はクロスドメインの指定が可能。
      #{'    '}
      - script要素
          - script要素にsrc属性を指定すると他のサイトからJavaScriptを読み込むことができる。
      #{'    '}
      - CSS
          - CSSはクロスドメインでの読み込みができる。
      #{'    '}
      - form属性のaction要素
          - form属性のaction要素もクロスドメインの指定ができる。また、formの送信はJavaScriptから常に操作できる。これを悪用した攻撃手法がクロスサイト・リクエストフォージェリ(CSRF)
      #{'    '}

      ## CORS(Cross-Origin Resource Sharing)
      - 同一オリジンポリシーの制限を超えて、サイト間でデータのやり取りをするための仕様。
      - シンプルなリクエストの場合は、次のHTTPレスポンスヘッダを付与して送信する。

      ```
      Access-Control-Allow-Origin: http://example.jp
      ```
      - シンプルでないリクエストの場合、ブラウザはプリフライトリクエストというHTTPリクエストを送信する。
      - クッキーなどの認証用のヘッダを伴うクロスオリジンリクエストは、次の両方を満たす必要がある。
          - XMLHttpRequestオブジェクトのwithCredentialsプロパティをtrueにする
          - レスポンスヘッダとしてAccess-Control-Allow-Credentials: trueを返す
    CHAPTER_3_FILE

    TEST_COMMIT_MESSAGES_FILE_CONTENT = <<~COMMIT_MESSAGES_FILE
      ---
      tags: ["English", "Messages", "git"]
      ---
      ## Commit messages: コミットメッセージ向け
      ### エラーの解消
      - Suppressed unused-export warnings

      ### 定数と型を集約化
      - Consolidate constants and types for the report domain

      ### hooksから純粋関数を切り分け
      - Extract pure utility functions from hooks

      ## コミットメッセージ例文集
      - URL: https://gist.github.com/mono0926/e6ffd032c384ee4c1cef5a2aa4f778d7

      ### 追加: Add
      - メソッドや機能、ファイルやオプションを追加したときに使う
      - "Add ~ to/for ~"の形式が多い
      #### 例
      - Add Throws flag and ThrowsLoc to AbstractFunctionDecl
      - Add build script
      - Add a typealias to avoid a build ordering dependency between projects
      - Add a helper method mayHaveOpenedArchetypeOperands to SILInstruction

      ### 切り替え: Use ~ instead of ~
      - 何かを別のものに切り替えた場合は"Use ~ instead of ~"を使うことが多いようだ
      - また、"Change ~ to ~"も使う
      #### 例
      - Use arrays instead of while loops
      - Use weak pointer instead of manual bookkeeping
      - Change all uses of 'CInt' to 'Int32' in the SDK overlay
      - Change Integer#year to return a Fixnum instead of a Float to improve consistency

      ### 対応/制限解除/可能
      - Add support for/Make it possible to/Allowを使う
      #### 例
      - Add support for closure contexts to readMetadataFromInstance()
          - 該当の関数がクロージャのコンテキストを取り扱えるようにした
      - Add support for activating and deactivating package-specific keymaps
      - Add support for launching HTML files directly
      - Make it possible to call `reflect` multiple times
      - Make it possible to set a data type for variables that come out of constants
          - 定数の結果から出てくる変数に型を適用した
      - Allow pane to be shrunk independently of its contents' width
          - ペインをコンテンツ幅と独立して縮小できるようにした

      ### リネーム: 名前の修正
      - "Rename ~ to ~"とする
      #### 例
      - Rename environment -> environmentHelpers
      - Rename watchProjectPath to watchProjectPaths
      - Rename generic arguments
      - fullVersion -> writeFullVersion
    COMMIT_MESSAGES_FILE

    TEST_REVIEW_FILE_CONTENT = <<~REVIEW_FILE
      ---
      tags: ["English", "Messages"]
      ---
      ## Review: レビューに関するやり取り

      ### レビューを見てもらうとき
      1. Could you review my PR at your Convenience?
      2. Could you take a look at my PR when you get a chance?

      ### 再レビュー
      1. Could you re-review my PR when you get a chance?
      2. Could you re-review my PR and also check this when you get a chance?
          a. これも見てほしい、のニュアンス

      ### 指摘事項の修正
      1. Updated the code based on feedback from AI.

      ### PRの説明
      1. This PR only changes the folder structure for domain/report.
      2. This PR fixes the bug in report list table.
    REVIEW_FILE

    TEST_VOCABULARY_FILE_CONTENT = <<~VOCABULARY_FILE
      ---
      tags: ["English", "Vocabulary"]
      ---
      ## Vocabulary: 英単語帳
      - opaque: 不透明な, not able to be seen through
    VOCABULARY_FILE

    TEST_RUIGO_FILE_CONTENT = <<~RUIGO_FILE
      ---
      tags: ["日本語"]
      ---
      ## 類義: ある言葉について、その言葉と近い意味を持つ言葉のメモ帳
      - 儚い
          - 空しい
    RUIGO_FILE

    TEST_MOCK_DATA_SEED = [
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/ANSI-escape-code-and-set-color.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/',
        parent_rel_path: './',
        filename: 'ANSI-escape-code-and-set-color',
        file_content: TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT,
        tags: %w[Terminal Charactor]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/chrome.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/',
        parent_rel_path: './',
        filename: 'chrome',
        file_content: TEST_CHROME_FILE_CONTENT,
        tags: %w[Browser Frontend]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/builtin/builtin.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/builtin/',
        parent_rel_path: 'cli/core/builtin/',
        filename: 'builtin',
        file_content: TEST_BUILTIN_FILE_CONTENT,
        tags: ['bash', 'CLI', 'builtin', 'Command inspection']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/builtin/hash.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/builtin/',
        parent_rel_path: 'cli/core/builtin/',
        filename: 'hash',
        file_content: TEST_HASH_FILE_CONTENT,
        tags: ['bash', 'CLI', 'builtin', 'Command inspection']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/file/ls.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/file/',
        parent_rel_path: 'cli/core/file/',
        filename: 'ls',
        file_content: TEST_LS_FILE_CONTENT,
        tags: ['bash', 'CLI', 'File and Directory', '表示']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/old/groups.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/old/',
        parent_rel_path: 'cli/core/old/',
        filename: 'groups',
        file_content: TEST_GROUPS_FILE_CONTENT,
        tags: %w[bash CLI legacy]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/process/lsof.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/process/',
        parent_rel_path: 'cli/core/process/',
        filename: 'lsof',
        file_content: TEST_LSOF_FILE_CONTENT,
        tags: %w[bash CLI process terminate]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/search/find.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/search/',
        parent_rel_path: 'cli/core/search/',
        filename: 'find',
        file_content: TEST_FIND_FILE_CONTENT,
        tags: %w[bash CLI search bulk pipe recursive]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/cut.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'cut',
        file_content: TEST_CUT_FILE_CONTENT,
        tags: %w[bash CLI text filter remove]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/diff.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'diff',
        file_content: TEST_CLI_CORE_TEXT__FILE_CONTENT,
        tags: %w[bash CLI text]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/ed.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'ed',
        file_content: TEST_ED_FILE_CONTENT,
        tags: %w[bash CLI text legacy]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/rev.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'rev',
        file_content: TEST_REV_FILE_CONTENT,
        tags: %w[bash CLI text reverse]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/tac.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'tac',
        file_content: TEST_TAC_FILE_CONTENT,
        tags: %w[bash CLI text reverse]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/uniq.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'uniq',
        file_content: TEST_UNIQ_FILE_CONTENT,
        tags: %w[bash CLI text set edit filter remove 集計]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/core/text/xargs.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/core/text/',
        parent_rel_path: 'cli/core/text/',
        filename: 'xargs',
        file_content: TEST_XARGS_FILE_CONTENT,
        tags: %w[bash CLI text bulk edit pipe search 集計]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/ifconfig.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/',
        parent_rel_path: 'cli/',
        filename: 'ifconfig',
        file_content: TEST_IFCONFIG_FILE_CONTENT,
        tags: %w[CLI Network 表示]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/tcpdump.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/',
        parent_rel_path: 'cli/',
        filename: 'tcpdump',
        file_content: TEST_TCPDUMP_FILE_CONTENT,
        tags: %w[CLI Network]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/third-party/claude.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/third-party/',
        parent_rel_path: 'cli/third-party/',
        filename: 'claude',
        file_content: TEST_CLAUDE_FILE_CONTENT,
        tags: ['CLI', 'External Command', 'AI', 'CLI client']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/third-party/gh.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/third-party/',
        parent_rel_path: 'cli/third-party/',
        filename: 'gh',
        file_content: TEST_GH_FILE_CONTENT,
        tags: ['CLI', 'Third Party', 'git', 'CI/CD', 'CLI client']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/third-party/mise.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/third-party/',
        parent_rel_path: 'cli/third-party/',
        filename: 'mise',
        file_content: TEST_MISE_FILE_CONTENT,
        tags: ['CLI', 'External Command', 'Package Manager', 'Runtime Version Manager']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/third-party/nkf.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/third-party/',
        parent_rel_path: 'cli/third-party/',
        filename: 'nkf',
        file_content: TEST_NKF_FILE_CONTENT,
        tags: ['CLI', 'External Command', 'text', '表示', '変換', 'Character Inspection', 'edit']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/cli/units.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/cli/',
        parent_rel_path: 'cli/',
        filename: 'units',
        file_content: TEST_UNITS_FILE_CONTENT,
        tags: ['CLI']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/db/sqlite3/sqlite3.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/db/sqlite3/',
        parent_rel_path: 'db/sqlite3/',
        filename: 'sqlite3',
        file_content: TEST_SQLITE3_FILE_CONTENT,
        tags: []
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/branch.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'branch',
        file_content: TEST_BRANCH_FILE_CONTENT,
        tags: ['CLI', 'git', 'Branching and Merging']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/config.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'config',
        file_content: TEST_CONFIG_FILE_CONTENT,
        tags: %w[CLI git Setting]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/diff.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'diff',
        file_content: TEST_GIT__FILE_CONTENT,
        tags: ['CLI', 'git', 'Basic Snapshotting', 'Comparison Version', 'Patching']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/git.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'git',
        file_content: TEST_GIT_FILE_CONTENT,
        tags: %w[CLI git documentation]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/log.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'log',
        file_content: TEST_LOG_FILE_CONTENT,
        tags: ['CLI', 'git', 'Branching and Merging', 'Inspection Version']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/old/checkout.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/old/',
        parent_rel_path: 'git/old/',
        filename: 'checkout',
        file_content: TEST_CHECKOUT_FILE_CONTENT,
        tags: ['CLI', 'git', 'Branching and Merging', 'legacy']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/push.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'push',
        file_content: TEST_PUSH_FILE_CONTENT,
        tags: ['CLI', 'git', 'Sharing and Updating Projects']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/reset.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'reset',
        file_content: TEST_RESET_FILE_CONTENT,
        tags: ['CLI', 'git', 'Basic Snapshotting']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/rev-parse.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'rev-parse',
        file_content: TEST_REV_PARSE_FILE_CONTENT,
        tags: ['CLI', 'git', 'Plumbing Commands']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/git/upstream.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/git/',
        parent_rel_path: 'git/',
        filename: 'upstream',
        file_content: TEST_UPSTREAM_FILE_CONTENT,
        tags: ['git', 'Sharing and Updating Projects', 'Branching and Merging', 'Option']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/how-to/data-exchanger.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/how-to/',
        parent_rel_path: 'how-to/',
        filename: 'data-exchanger',
        file_content: TEST_DATA_EXCHANGER_FILE_CONTENT,
        tags: ['How to', 'Network']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/how-to/random.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/how-to/',
        parent_rel_path: 'how-to/',
        filename: 'random',
        file_content: TEST_RANDOM_FILE_CONTENT,
        tags: ['How to', 'Generator']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/how-to/special-characters.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/how-to/',
        parent_rel_path: 'how-to/',
        filename: 'special-characters',
        file_content: TEST_SPECIAL_CHARACTERS_FILE_CONTENT,
        tags: ['How to', 'Characters', 'Keyboard']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/css/hover.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/css/',
        parent_rel_path: 'lang/css/',
        filename: 'hover',
        file_content: TEST_HOVER_FILE_CONTENT,
        tags: %w[CSS 擬似クラス]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/javascript/console.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/javascript/',
        parent_rel_path: 'lang/javascript/',
        filename: 'console',
        file_content: TEST_CONSOLE_FILE_CONTENT,
        tags: ['JavaScript', 'Debug', 'I/O']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/javascript/map.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/javascript/',
        parent_rel_path: 'lang/javascript/',
        filename: 'map',
        file_content: TEST_MAP_FILE_CONTENT,
        tags: %w[JavaScript 連想配列 データ構造 Notation]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/javascript/package-json.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/javascript/',
        parent_rel_path: 'lang/javascript/',
        filename: 'package-json',
        file_content: TEST_PACKAGE_JSON_FILE_CONTENT,
        tags: ['JavaScript', 'Package Manager', 'Setting']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/lua/lua.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/lua/',
        parent_rel_path: 'lang/lua/',
        filename: 'lua',
        file_content: TEST_LUA_FILE_CONTENT,
        tags: ['lua', 'Package Manager', 'Linter', 'Setting', 'Formatter']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/perl/oneliner.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/perl/',
        parent_rel_path: 'lang/perl/',
        filename: 'oneliner',
        file_content: TEST_ONELINER_FILE_CONTENT,
        tags: %w[perl oneliner 表示 edit substitute regex]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/arguments.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'arguments',
        file_content: TEST_ARGUMENTS_FILE_CONTENT,
        tags: %w[Ruby 引数 TODO]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/assignment.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'assignment',
        file_content: TEST_ASSIGNMENT_FILE_CONTENT,
        tags: %w[Ruby 配列 演算子式 初期化]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/bundle.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'bundle',
        file_content: TEST_BUNDLE_FILE_CONTENT,
        tags: ['CLI', 'Ruby', 'Project Manager', 'Dependency Management']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/compare.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'compare',
        file_content: TEST_COMPARE_FILE_CONTENT,
        tags: %w[Ruby 比較]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/index.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'index',
        file_content: TEST_INDEX_FILE_CONTENT,
        tags: %w[Ruby Idiom]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/module.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'module',
        file_content: TEST_MODULE_FILE_CONTENT,
        tags: %w[Ruby TODO]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/rake.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'rake',
        file_content: TEST_RAKE_FILE_CONTENT,
        tags: ['Ruby', 'Task Runner']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/string.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'string',
        file_content: TEST_STRING_FILE_CONTENT,
        tags: %w[Ruby string Creation Concatenation データ構造]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/ruby/type-check.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/ruby/',
        parent_rel_path: 'lang/ruby/',
        filename: 'type-check',
        file_content: TEST_TYPE_CHECK_FILE_CONTENT,
        tags: %w[Ruby 型検査]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/lang/test-assertion.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/lang/',
        parent_rel_path: 'lang/',
        filename: 'test-assertion',
        file_content: TEST_TEST_ASSERTION_FILE_CONTENT,
        tags: ['テストコード']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/meta/format.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/meta/',
        parent_rel_path: 'meta/',
        filename: 'format',
        file_content: TEST_FORMAT_FILE_CONTENT,
        tags: %w[meta format]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/buffer.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/',
        parent_rel_path: 'neovim/',
        filename: 'buffer',
        file_content: TEST_BUFFER_FILE_CONTENT,
        tags: ['neovim', 'buffer', 'Command Line Mode']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/commenting.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/',
        parent_rel_path: 'neovim/',
        filename: 'commenting',
        file_content: TEST_COMMENTING_FILE_CONTENT,
        tags: ['neovim', 'Comment Out', 'documentation']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/plugin/neo-tree.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/plugin/',
        parent_rel_path: 'neovim/plugin/',
        filename: 'neo-tree',
        file_content: TEST_NEO_TREE_FILE_CONTENT,
        tags: %w[neovim plugin documentation]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/plugin/nvim-surround.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/plugin/',
        parent_rel_path: 'neovim/plugin/',
        filename: 'nvim-surround',
        file_content: TEST_NVIM_SURROUND_FILE_CONTENT,
        tags: ['neovim', 'plugin', 'Operator', 'Normal Mode', 'documentation']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/read-help.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/',
        parent_rel_path: 'neovim/',
        filename: 'read-help',
        file_content: TEST_READ_HELP_FILE_CONTENT,
        tags: %w[neovim documentation]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/script.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/',
        parent_rel_path: 'neovim/',
        filename: 'script',
        file_content: TEST_SCRIPT_FILE_CONTENT,
        tags: ['neovim']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/neovim/tips.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/neovim/',
        parent_rel_path: 'neovim/',
        filename: 'tips',
        file_content: TEST_TIPS_FILE_CONTENT,
        tags: %w[neovim Tips Motion]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/react.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/',
        parent_rel_path: './',
        filename: 'react',
        file_content: TEST_REACT_FILE_CONTENT,
        tags: ['Frontend']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/setting/dockerfile.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/setting/',
        parent_rel_path: 'setting/',
        filename: 'dockerfile',
        file_content: TEST_DOCKERFILE_FILE_CONTENT,
        tags: ['Docker']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/setting/makefile.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/setting/',
        parent_rel_path: 'setting/',
        filename: 'makefile',
        file_content: TEST_MAKEFILE_FILE_CONTENT,
        tags: ['Task Runner']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/bash/bash.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/bash/',
        parent_rel_path: 'shell/bash/',
        filename: 'bash',
        file_content: TEST_BASH_FILE_CONTENT,
        tags: %w[bash documentation Tips]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/bash/exit-status.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/bash/',
        parent_rel_path: 'shell/bash/',
        filename: 'exit-status',
        file_content: TEST_EXIT_STATUS_FILE_CONTENT,
        tags: %w[bash test status]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/bash/expansion/history-expansion.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/bash/expansion/',
        parent_rel_path: 'shell/bash/expansion/',
        filename: 'history-expansion',
        file_content: TEST_HISTORY_EXPANSION_FILE_CONTENT,
        tags: %w[bash expansion]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/bash/for.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/bash/',
        parent_rel_path: 'shell/bash/',
        filename: 'for',
        file_content: TEST_FOR_FILE_CONTENT,
        tags: %w[bash syntax documentation]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/bash/redirection.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/bash/',
        parent_rel_path: 'shell/bash/',
        filename: 'redirection',
        file_content: TEST_REDIRECTION_FILE_CONTENT,
        tags: ['bash', 'Redirection', 'I/O', 'documentation']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/bash/special-parameters.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/bash/',
        parent_rel_path: 'shell/bash/',
        filename: 'special-parameters',
        file_content: TEST_SPECIAL_PARAMETERS_FILE_CONTENT,
        tags: %w[bash Notation Tips documentation]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/shell/zsh/command-history.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/shell/zsh/',
        parent_rel_path: 'shell/zsh/',
        filename: 'command-history',
        file_content: TEST_COMMAND_HISTORY_FILE_CONTENT,
        tags: ['zsh', 'documentation', 'command history']
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/tui/emacs.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/tui/',
        parent_rel_path: 'tui/',
        filename: 'emacs',
        file_content: TEST_EMACS_FILE_CONTENT,
        tags: %w[TUI Tips]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/tui/lazygit.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/tui/',
        parent_rel_path: 'tui/',
        filename: 'lazygit',
        file_content: TEST_LAZYGIT_FILE_CONTENT,
        tags: %w[TUI Terminal git]
      },
      {
        absolute_path: '/Users/hy/repo/memorandum/memo/tui/tmux.md',
        parent_directory: '/Users/hy/repo/memorandum/memo/tui/',
        parent_rel_path: 'tui/',
        filename: 'tmux',
        file_content: TEST_TMUX_FILE_CONTENT,
        tags: %w[TUI Terminal]
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/architecture/null.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/architecture/',
        parent_rel_path: 'architecture/',
        filename: 'null',
        file_content: TEST_NULL_FILE_CONTENT,
        tags: []
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/books/compiler/compiler-memo.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/books/compiler/',
        parent_rel_path: 'books/compiler/',
        filename: 'compiler-memo',
        file_content: TEST_COMPILER_MEMO_FILE_CONTENT,
        tags: ['コンパイラ']
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/books/was-book/chapter-3.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/books/was-book/',
        parent_rel_path: 'books/was-book/',
        filename: 'chapter-3',
        file_content: TEST_CHAPTER_3_FILE_CONTENT,
        tags: %w[Security HTTP]
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/english/commit-messages.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/english/',
        parent_rel_path: 'english/',
        filename: 'commit-messages',
        file_content: TEST_COMMIT_MESSAGES_FILE_CONTENT,
        tags: %w[English Messages git]
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/english/review.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/english/',
        parent_rel_path: 'english/',
        filename: 'review',
        file_content: TEST_REVIEW_FILE_CONTENT,
        tags: %w[English Messages]
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/english/vocabulary.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/english/',
        parent_rel_path: 'english/',
        filename: 'vocabulary',
        file_content: TEST_VOCABULARY_FILE_CONTENT,
        tags: %w[English Vocabulary]
      },
      {
        absolute_path: '/Users/hy/repo/private-memo/memo/japanese/ruigo.md',
        parent_directory: '/Users/hy/repo/private-memo/memo/japanese/',
        parent_rel_path: 'japanese/',
        filename: 'ruigo',
        file_content: TEST_RUIGO_FILE_CONTENT,
        tags: ['日本語']
      }
    ].freeze
  end
end
