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
    NO_GIVEN_TAGS = <<~NO_G
      memo tagには引数が必要です。
      memo tagの後にタグ名を指定してください。
    NO_G
  end
end
