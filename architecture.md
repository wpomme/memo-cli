## Memoの内部構造
1. SubCommandParser
    - memo CLIで受け取った引数の解析

2. Command
    - 受け取った引数にしたがって、どのコマンドを実行するかを決定する

3. CommandView
    - 受け取ったコマンドにしたがって、表示する内容を決定する

- Service
    - Repositoryに依存しないメソッドを保存するモジュール

- Config
    - config/config.ymlを読み取るためのモジュール

- Message
    - ユーザーに表示するメッセージを保存するためのモジュール

- Version
    - Memo CLIのバージョン情報

## 依存関係
