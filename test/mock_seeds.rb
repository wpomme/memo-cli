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

    TEST_BUILTIN_FILE_CONTENT_1 = <<~BUILTIN_FILE
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

    TEST_MISE_FILE_CONTENT = <<~MISE_FILE
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
    KEYMAP_FILE

    TEST_NVIM_SURROUND_FILE_CONTENT = <<~NVIM_SURROUND_FILE
      - nvim-surround
          - 文字列を記号で囲ってくれる
          - https://github.com/kylechui/nvim-surround

      {example}
      - ドキュメント
      :h nvim-surround | only
          - ドキュメントに便利なエイリアス集などが載っている

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

    TEST_EDITORCONFIG_FILE_CONTENT = <<~EDITORCONFIG_FILE
      - editorconfig
          - リポジトリのトップに.editorconfigを作成しておけばファイルのフォーマットが簡単にできる
          - サイトURL: https://editorconfig.org/
          - VimとNeovimは標準でサポートされている
    EDITORCONFIG_FILE

    TEST_BUILTIN_FILE_CONTENT_2 = <<~BUILTIN_FILE
      ## SHELL BUILTIN COMMANDS: 組み込みコマンド
      - ドキュメント
          - 組み込みコマンドのドキュメントはman bash のSHELL BUILTIN COMMANDS に記載がある
          - 例えば、cd, command, 
      ```bash
      man bash
      ## ^を付けないと結構いっぱい出てくる
      /^SHELL BUILTIN COMMANDS
      ```

      ## builtinコマンドと外部コマンド
      - bashには組み込みコマンドと外部コマンドがある
      - `ls`などは外部コマンドである。
          - coreutils(GNU/Linux)かmacOSのシステムユーティリティとして提供されている外部コマンド
    BUILTIN_FILE

    TEST_HISTORY_EXPANSION_FILE_CONTENT = <<~HISTORY_EXPANSION_FILE
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

    TEST_SHELL_VARIABLES_FILE_CONTENT = <<~SHELL_VARIABLES_FILE
      ### special parameterstと内容が被るけど、memoから見つけられなかった...
      ### man bashから記号を検索するのが面倒すぎる...
      ### /?で検索すればOK

      - シェル変数
          - $?: 直前に実行したコマンドの実行ステータス
          - $!: 直前に実行したコマンドのプロセスID
          -> 大体どっちも0で帰ってきたりするから分かりにくい
    SHELL_VARIABLES_FILE

    TEST_ZSH_FILE_CONTENT = <<~ZSH_FILE
      Mac OSのデフォルトシェル

      ## history コマンドのドキュメント
      ```sh
      $ man zshbuitins
      ```

      /historyで検索すると、"Same as fc -l" と記載がある
      -> zshではhistoryコマンドの代わりにfc -lコマンドを使う

      ## 履歴展開 (History Expansion)
      - 最近のstringで始まるコマンドを履歴展開で補完して、実行したい場合
          - `!"string"`まで入力して、`Tab`キーを押すと、該当のコマンドが展開される。該当のコマンドが正しいことを確認して実行ができる。
      ```sh
      $ !string
      ```

      - zsh-completions
          - "zsh compinit: insecure directories"というwarningが出たら次を実行する
          1. `compaudit`を実行
          2. 信頼できないパスの一覧が出る。信頼できれば次を実行する
              - `chmod go-w '/path/to/file'`
              - `chmod -R go-w '/path/to/file'`

      # ディレクトリ移動コマンドとzsh の設定
      - 次の設定をdotfilesに記載してある
      ```zsh
      # cd すると自動でpushd する
      setopt autopushd

      # pushd に同じディレクトリを重複させない
      setopt pushdignoredups
      ```

      - dirs, pushd, popdについて
      ```
      # デフォルトだとディレクトリの遷移が見にくいので-v をalias に設定する
      alias dirs="dirs -v"

      ## 数値の前に+ を付けなければいけないのが面倒...
      # pushd +<number> でdirs -v で指定されたディレクトリに移動する
      pushd +3

      # popd +<number> でdir -v で指定されたディレクトリの履歴を消去する
      popd +3
      ```
    ZSH_FILE

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
        dir: "memo",
        filename: "ANSI-escape-code-and-set-color",
        content: TEST_ANSI_ESCAPE_CODE_AND_SET_COLOR_FILE_CONTENT
      },
      {
        dir: "cli/builtin",
        filename: "builtin",
        content: TEST_BUILTIN_FILE_CONTENT_1
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
        content: TEST_MISE_FILE_CONTENT
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
        dir: "memo",
        filename: "markdown",
        content: TEST_MARKDOWN_FILE_CONTENT
      },
      {
        dir: "neovim",
        filename: "keymap",
        content: TEST_KEYMAP_FILE_CONTENT
      },
      {
        dir: "neovim/plugin",
        filename: "nvim-surround",
        content: TEST_NVIM_SURROUND_FILE_CONTENT
      },
      {
        dir: "neovim",
        filename: "script",
        content: TEST_SCRIPT_FILE_CONTENT
      },
      {
        dir: "setting",
        filename: "editorconfig",
        content: TEST_EDITORCONFIG_FILE_CONTENT
      },
      {
        dir: "shell/bash",
        filename: "builtin",
        content: TEST_BUILTIN_FILE_CONTENT_2
      },
      {
        dir: "shell/bash",
        filename: "history-expansion",
        content: TEST_HISTORY_EXPANSION_FILE_CONTENT
      },
      {
        dir: "shell/bash",
        filename: "shell-variables",
        content: TEST_SHELL_VARIABLES_FILE_CONTENT
      },
      {
        dir: "shell/zsh",
        filename: "zsh",
        content: TEST_ZSH_FILE_CONTENT
      },
      {
        dir: "tui",
        filename: "tmux",
        content: TEST_TMUX_FILE_CONTENT
      }
    ].freeze
  end
end
