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

    TEST_BUILTIN_FILE_CONTENT = <<~BUILTIN_FILE
      ## builtin: そのコマンドがbuiltinかどうかを判別する
      - 組み込みだと正常終了し、何も帰ってこない
      - それ以外だと何かが帰ってくる
      - cdがカスタマイズされてないかどうかを調べたりするのに使うらしい
    BUILTIN_FILE

    TEST_CLAUDE_FILE_CONTENT = <<~CLAUDE_FILE
      # claude CLI
      - `/resume`
      過去のセッションを選択して再開する
    CLAUDE_FILE

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

    TEST_HOMEBREW_FILE_CONTENT = <<~HOMEBREW_FILE
      - 自分でインストールしたパッケージを確認するとき
      # TODO: homebrew の設定に関することは docs/setting/homebrew.md に書く
      ```bash
      brew leaves -r
      ```
      - -r, --installed-on-request: 自分で入れたパッケージ
      - -p, --installed-as-dependency: 他と依存関係がないパッケージ

      - パッケージの情報を確認するとき
          - インストールしたパッケージについて、warningが出た場合の対処法などが書いてあったりする
      ```bash
      brew info <package>
      ```
    HOMEBREW_FILE

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

    TEST_GROUPS_FILE_CONTENT = <<~GROUPS_FILE
      - groups: グループを表示する
          - idコマンドにより廃止された
          - `id -Gn [user]`と同等である
    GROUPS_FILE

    TEST_SSH_FILE_CONTENT = <<~SSH_FILE
      ```bash
      ssh <login name>@<address>
      ```
    SSH_FILE

    TEST_WC_FILE_CONTENT = <<~WC_FILE.freeze
      ## オプション
      出力される数値は、行数・単語数・バイト数の順番で並んでいる#{'  '}

      - -l: 行数のみ出力
      - -c: バイト数のみ出力
      - -m: 文字数でカウント。通常はUTF-8で数える。日本語も一文字としてカウント
      - -w: 単語数のみ出力。日本語だと使う意味がそこまでない。
    WC_FILE

    TEST_APPLY_FILE_CONTENT = <<~APPLY_FILE
      - パッチファイルを適用する
      ```bash
      git apply <filename>

      # 例
      git apply patch.diff
      ```

      - patchコマンドでも差分を取り込めるらしい
    APPLY_FILE

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

    TEST_GITIGNORE_FILE_CONTENT = <<~GITIGNORE_FILE
      - .gitignore
      ## ローカル環境だけでgitignoreを設定するには
      .git/info/excludeに該当のファイル・フォルダ名を書けばいい
    GITIGNORE_FILE

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

    TEST_SERVER_FILE_CONTENT = <<~SERVER_FILE
      - server: 簡易的なWebサーバーを起動させる方法
      ```bash
      # ruby
      ruby -rwebrick -e 'WEBrick::HTTPServer.new({:DocumentRoot => "./"}).start'

      # python
      python3 -m http.server 8000
      ```
    SERVER_FILE

    TEST_JSDOC_FILE_CONTENT = <<~JSDOC_FILE.freeze
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

    TEST_NAMING_CONVENTION_FILE_CONTENT = <<~NAMING_CONVENTION_FILE
      ## 命名規則
      - プログラミングで大事な命名の、その規則や習慣について

      - 対になっている
          - synonym antonym dictionaryがあったらいいかも
          Entry <-> Collection
    NAMING_CONVENTION_FILE

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

      - 自分でインストールしたgemの一覧
          - (1)インストール先を指定して確認するコマンドや、(2)インストール場所ごとに分けて確認するコマンドを組み合わせて確認する。
          1. `gem list -d`
          2. `gem environment`
    GEM_FILE

    TEST_TEST_ASSERTION_FILE_CONTENT = <<~TEST_ASSERTION_FILE
      ## テストアサーションについて
      - いつもexpectedとactualを逆に書いている気がする......。
      - 文献がいつもexpectedとactualが逆なような......


      ### Ruby
      minitestのspecはこれが正しいはず！
      ```ruby
      _expected).must_equal(actual)
      ```
    TEST_ASSERTION_FILE

    TEST_COMMENTING_FILE_CONTENT = <<~COMMENTING_FILE
      - commenting: コメントアウトなどの操作
      ```
      # ドキュメントはcommenting で検索する
      :h commenting
      ```
    COMMENTING_FILE

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

    TEST_EXPANSION_FILE_CONTENT = <<~EXPANSION_FILE.freeze
      ## EXPANSION: bashのコマンドや変数の展開
      ### ドキュメント
      EXPANSIONという章がある。次のように検索すればその章に行ける
      ```
      /^EXPANSION#{' '}
      ```

      ### 関係
      - Command Substitution(コマンド展開)とも大きな関係がある

      ### コマンド展開: Command Substitution
      - 次のようにしてコマンドを展開する
      ```
      $(command)
      # or
      `command`
      ```

      - *補足
      man bashの中で、Substitutionを全部大文字にしてSUBSTITUTIONで検索しても見つからない。

      ### パラメーター展開: Parameter Expansion
      - '$'がパラーメーター展開、コマンド展開、算術展開の橋渡しをする
      - '{}'(ブレース)で囲まなくてもいいけど、他の文字列と混同することを防ぐ役割がある

      ```
      ## man bashの Parameter Expansionの冒頭からの引用
      > The `$' character introduces parameter expansion, command substitution, or arithmetic expansion.
      > The parameter name or symbol to be expanded may be enclosed in braces, which are optional but serve to protect
      > the variable to be expanded from characters immediately following it which could be interpreted as part of the name.
      ```

      ### プロセス置換 (Process Substitution)
      - 構文
          - listの実行結果を、ファイルのように扱うことができる
      ```bash
      <(list)
      ```
      または、
      ```bash
      >(list)
      ```

      ### 例
      - diffなどの、引数としてファイルを要求するコマンドに使用する
      ```bash
      diff <(list) <(list)
      ```

      ## 補足
      プロセス置換は、実行されたコマンドの出力をファイル記述子と関連づける。echoを使うと関連づけられたファイル記述子の番号が確認できる。
      ```bash
      $ echo <(ls)
      ```
    EXPANSION_FILE

    TEST_REDIRECTION_FILE_CONTENT = <<~REDIRECTION_FILE
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

    TEST_TEST_FILE_CONTENT = <<~TEST_FILE
      - test,[
          - man testが詳しい
      ```bash
      man test

      # [ に man を適用してもドキュメントが読める
      man [
      ```
    TEST_FILE

    TEST_GHOSTTY_FILE_CONTENT = <<~GHOSTTY_FILE
      ## 例
      - 新規タブを作成
      <kbd>⌘</kbd> + <kbd>T</kbd>

      - タブを移動
          - <kbd>Shift</kbd> + <kbd>⌘</kbd> + <kbd>[</kbd>
          - <kbd>Shift</kbd> + <kbd>⌘</kbd> + <kbd>]</kbd>
    GHOSTTY_FILE

    TEST_DIFF_FILE_CONTENT = <<~DIFF_FILE
      - diff

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

    TEST_MEMO_DATA_SEED = [
      {
        dir: "memo",
        filename: "ANSI-escape-code-and-set-color",
        content: TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT
      },
      {
        dir: "cli/builtin",
        filename: "builtin",
        content: TEST_BUILTIN_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "claude",
        content: TEST_CLAUDE_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "ed",
        content: TEST_ED_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "homebrew",
        content: TEST_HOMEBREW_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "mise",
        content: TEST_MISE_FILE_CONTENT_1
      },
      {
        dir: "cli/old",
        filename: "groups",
        content: TEST_GROUPS_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "ssh",
        content: TEST_SSH_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "wc",
        content: TEST_WC_FILE_CONTENT
      },
      {
        dir: "git",
        filename: "apply",
        content: TEST_APPLY_FILE_CONTENT
      },
      {
        dir: "git",
        filename: "config",
        content: TEST_CONFIG_FILE_CONTENT
      },
      {
        dir: "git",
        filename: "gitignore",
        content: TEST_GITIGNORE_FILE_CONTENT
      },
      {
        dir: "git",
        filename: "push",
        content: TEST_PUSH_FILE_CONTENT
      },
      {
        dir: "git",
        filename: "rev-parse",
        content: TEST_REV_PARSE_FILE_CONTENT
      },
      {
        dir: "how-to",
        filename: "server",
        content: TEST_SERVER_FILE_CONTENT
      },
      {
        dir: "lang/javascript",
        filename: "jsdoc",
        content: TEST_JSDOC_FILE_CONTENT
      },
      {
        dir: "lang",
        filename: "naming-convention",
        content: TEST_NAMING_CONVENTION_FILE_CONTENT
      },
      {
        dir: "lang/ruby",
        filename: "gem",
        content: TEST_GEM_FILE_CONTENT
      },
      {
        dir: "lang",
        filename: "test-assertion",
        content: TEST_TEST_ASSERTION_FILE_CONTENT
      },
      {
        dir: "neovim",
        filename: "commenting",
        content: TEST_COMMENTING_FILE_CONTENT
      },
      {
        dir: "neovim/plugin",
        filename: "netrw",
        content: TEST_NETRW_FILE_CONTENT
      },
      {
        dir: "neovim",
        filename: "read-only",
        content: TEST_READ_ONLY_FILE_CONTENT
      },
      {
        dir: "setting",
        filename: "docker-compose",
        content: TEST_DOCKER_COMPOSE_FILE_CONTENT
      },
      {
        dir: "setting",
        filename: "mise",
        content: TEST_MISE_FILE_CONTENT_2
      },
      {
        dir: "shell/bash",
        filename: "expansion",
        content: TEST_EXPANSION_FILE_CONTENT
      },
      {
        dir: "shell/bash",
        filename: "redirection",
        content: TEST_REDIRECTION_FILE_CONTENT
      },
      {
        dir: "shell/bash",
        filename: "test",
        content: TEST_TEST_FILE_CONTENT
      },
      {
        dir: "tui",
        filename: "ghostty",
        content: TEST_GHOSTTY_FILE_CONTENT
      },
      {
        dir: "cli",
        filename: "diff",
        content: TEST_DIFF_FILE_CONTENT
      }
    ].freeze
  end
end
