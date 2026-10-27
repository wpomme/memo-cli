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
    NO_GIVEN_ARGS = <<~NO_ARGS
      memo CLIには引数が必要です。
      memo CLIの後にタグ名を指定してください。
    NO_ARGS
    TOO_MANY_ARGS = <<~TOO_ARGS
      memo CLIに必要な引数の数を超えています。
      適切な数の引数を指定してください。
    TOO_ARGS
    TOO_LONG_ARGS = <<~TOO_LONG
      memo CLIが引数として取る文字列が長すぎます。
      適切な長さの文字列を指定してください。
    TOO_LONG
    TOO_MANY_OPTIONS = <<~TOO_OPTS
      memo CLIのオプションは同時に指定することができません。
    TOO_OPTS
    UNKNOWN_COMMAND = <<~UNKNOWN
      memo CLIにそのようなサブコマンドはありません。
      適切なサブコマンドを指定してください。
    UNKNOWN
    NO_EMPTY_TAGS_FILE_LIST = <<~NO_EMPTY
      タグ付けされていないファイルはありませんでした。
    NO_EMPTY
    INTERRUPT_PROMPT = '処理を中断します'
  end
end
