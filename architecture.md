## Memoの内部構造
1. SubCommandParser
    - memo CLIで受け取った引数の解析

2. Command
    - 受け取った引数にしたがって、どのコマンドを実行するかを決定する

3. Repository
    - 対象のディレクトリからデータを取得する
        - seedsに直接触れるようなメソッドはRepositoryに持たせる

4. Mapper
    - 取得したデータをユーザー向けに加工
        - 色付け、日付のフォーマット、インデントなど

5. View
    - 受け取ったコマンドにしたがって、表示する内容を決定する

- Model
    - Repositoryに依存しない値オブジェクト
        - Data, Structで定義された静的な構造体の情報を記載している

- Service
    - Repositoryに依存しないメソッドを保存するモジュール

- Config
    - config/config.ymlを読み取るためのモジュール

- Message
    - ユーザーに表示するメッセージを保存するためのモジュール

- Version
    - Memo CLIのバージョン情報

## 依存関係
1. Model, Service, CommandParserはRepositoryに依存しない
2. Command, Mapper, ViewはRepositoryに依存する
3. Command -> View -> Mapper -> Repositoryの順で依存している
