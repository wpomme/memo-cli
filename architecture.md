## Memoの内部構造
1. 受け取った引数はSubCommandParserで解釈する
2. 引数を解釈した後はViewにコマンドの結果を出力させる
    a. SubCommandParserの後は、MVVMアーキテクチャを採用している
        - LoaderがModelの役割を果たしている

3. 実行順: Command => SubCommand => SubCommandParser => SubCommand => Command => View => ViewModel => Loader => ViewModel => View
4. その他のクラスやディレクトリについて
    - database
        - 対象のディレクトリの情報をsqlite3に保存するためのフォルダ
        - 値を保存するまでで、実用には至っていない
    - Config
        - config/config.ymlを読み取るためのモジュール

    - Message, HelpMessage
        - ユーザーに表示するメッセージを保存するためのモジュール

    - Service
        - 他のクラスに依存しないユーティリティ関数を置くためのモジュール

    - Structure
        - 構造体を定義するためのモジュール

    - Version
        - Memo CLIのバージョン情報
