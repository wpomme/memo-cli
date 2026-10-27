# frozen_string_literal: true

module Memo
  module HelpMessage
    GENERAL = <<~HELP_G
      memo CLI: ローカルのメモフォルダをコマンドで閲覧、検索するためのコマンド

      使い方: memo (subcommand) [arguments]
      例: memo list cli => memoフォルダ内のcliフォルダの中のメモの一覧を返す

      なお、サブコマンドを省略した場合はmemo readを実行する
      例: memo ls => フォルダ内のls.mdを検索して、あればls.mdを全文表示する

      サブコマンド(subcommand)のリスト:
          read FILE_NAME             対象のメモを全文表示する
          search WORD                検索した文字列で全てのメモを全文検索する
          list [DIR_NAME]            メモの一覧を表示する
          dirs                       メモの中のディレクトリの一覧を表示する
          tags [OPTION]              タグ名とそのタグ名が付いたファイル名の一覧を表示する
          tag TAG_NAME               与えらえたタグ名に対応するファイル名の一覧を表示する
          help                       memoコマンドのヘルプ
          version                    memoコマンドのバージョン
    HELP_G
    READ_DETAIL = <<~READ_D
      memo read: メモフォルダの中のファイルを全文表示するコマンド

      使い方: memo read FILE_NAME
          - ファイル名は必須

      なお、メモフォルダに同じ名前のファイルが二つ以上存在する場合は、
      その中からどのファイルを表示するかを選択するためのプロンプトが表示される。
    READ_D
    TAGS_OPTIONS_NAME = 'タグ名のみを表示する'
    TAGS_OPTIONS_COUNT = 'タグ名とそのタグが付いているファイルの数を表示する'
    TAGS_OPTIONS_EMPTY = 'タグの付いていないファイルの一覧を表示する'
    TAGS_DETAIL = <<~TAGS_D
      memo tags: メモフォルダに付いているタグの情報を表示するコマンド

      使い方: memo tags [OPTION]
          - オプションは任意で追加する

      コマンドリスト
      memo tags             => それぞれのタグと、そのタグが付けられているファイル名の一覧を表示する
      memo tags -n(--name)  => #{TAGS_OPTIONS_NAME}
      memo tags -c(--count) => #{TAGS_OPTIONS_COUNT}
      memo tags -e(--empty) => #{TAGS_OPTIONS_EMPTY}
      memo tags -h          => memo tagsのオプションについて簡単なヘルプを表示する
    TAGS_D
      .freeze
  end
end
