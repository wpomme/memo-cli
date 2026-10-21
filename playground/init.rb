# frozen_string_literal: true

## bundle exec irb で調べたこと
## ログイン
bundle exec irb

## rake consoleで必要なデータを作成する
# メモフォルダへの絶対パスを取得する
target_dirs = Memo::Config.target_dirs

# init-db
Memo::Config.target_database(database_path: 'test_memo.db')
