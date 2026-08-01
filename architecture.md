## Memoの内部構造
1. CommandParser
    - memo CLIで受け取った引数の解析
2. Command
    - 受け取った引数にしたがって、どのコマンドを実行するかを決定する
3. Repository
    - 対象のディレクトリからデータを取得する
        - seedsに直接触れるようなメソッドはRepositoryに持たせる
4. Model
    - Repositoryに依存しないメソッドと値オブジェクト
        - Seed, GroupedFileList, SearchLine
    - 取得するデータの構造を決定する
    - 取得したデータを加工する
5. Mapper
    - 取得したデータをユーザー向けに加工
        - 色付け、日付のフォーマット、インデントなど
6. View
    - 受け取ったコマンドにしたがって、表示するメッセージを決める

## 依存関係
1. Model, CommandParserはRepositoryに依存しない
2. Command, Mapper, ViewはRepositoryに依存する
3. Command -> View -> Mapper -> Repositoryの順で依存している
