# frozen_string_literal: true

module Memo
  module Message
    NO_MEMOS_WEWE_FOUND = 'wordというメモは見つかりませんでした。'
    MULTIPLE_MEMOS_WEWE_FOUND = 'メモがsize件あります。'
    NO_SEARCH_RESULTS_WERE_FOUND = 'wordで全文検索しましたが、そのような文字列は見当たりませんでした。'
    NO_DIRECTORIES = <<~NO_DIRS
      dirというディレクトリはありませんでした。
      ディレクトリの一覧は次の通りです。
    NO_DIRS
    NO_TAGS = <<~NO_T
      tagというタグはありませんでした。
      タグの一覧は次の通りです。
    NO_T
    NO_GIVEN_ARGS = <<~NO_G
      memo CLIには引数が必要です。
      memo CLIの後にタグ名を指定してください。
    NO_G
    OPT_BANNER = 'memo CLI: ローカルのメモフォルダをコマンドで閲覧、検索するためのコマンド'
    OPT_SEPARATOR_HEREDOCS = <<~SEPT
      new_line
      使い方: memo subcommand [arguments]
      例: memo list cli => memoフォルダ内のcliフォルダの中のメモの一覧を返す
      サブコマンドの--は省略可能
      また、サブコマンドを省略した場合はmemo readを実行するものとみなされる
      例: memo ls => フォルダ内のls.mdを検索して、あればls.mdを全文表示する
      new_line
      サブコマンド(subcommand)のリスト:
    SEPT
  end
end
