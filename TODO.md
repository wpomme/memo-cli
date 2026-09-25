## TODO・IDEA
### TODO
### 1. memo walkの作成
- `memo walk`というコマンドを作成する
    1. 実行したら、memoフォルダの階層のトップを表示させ、プロンプトで選択できるようにする
    2. フォルダを選択したら、そのフォルダの中を表示させる
        2.1. トップ以外のフォルダを表示している場合は、その親のフォルダに移動できるようにする
    3. ファイルを選択したら、そのファイルの全文を表示する

- DB連携=>タグ作成で同様のコマンドが作成できるはず
    - DB連携より先に作成する

### 2. DB連携
- sqlite3とSequelを使う
    - ファイルにタグ付けをする
        - yamlやFront Matterでtagを再現する案もある
        - タグ付けでネットワークのようなデータ構造を作成できないだろうか
        - タグ名の候補
            - CLI, bash, git, bulk, setting, TUI, editor, shell, AI, Application, Package Manager
            - CLI: File System, Process Management, User Management, Text Processor, Built-in
- DBモデル案
    - Memo: memo_id, rel_path, ...
        - メモのリネームや削除があるためIDは自動採番のものを使う
- その他DB構築に関する設計について
    - DBと接続するための設定をMemo::Configに入れる

### 3. memoフォルダ以外のフォルダも指定できるようにする
    - プライベート用のメモフォルダを作成して、その中に英語など公開したくないメモを入れたい

### その他
# テスト系
## 型検査・型のテスト・テスト拡張
- Rdocかyard、型検査の導入、coverageの取得

## モックデータ
    - 欲しいモックデータ
        - @fixed_mock_directory = 'cli'
        - @fixed_mock_duplicated_file = 'mise'
            - 別のsetup, teardownを作成するべきだろうか
        - @fixed_mock_file_under_root_dir = 'ANSI-escape-code-and-set-color'
            - ルートディレクトリ直下に保存されているファイルのモックデータを固定したい

## expected, actual
- expected, actualを意味的に逆に使っている箇所があるかもしれない
    - 洗い出す

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

#### CLIの自動補完機能
