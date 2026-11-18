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
    CHECK_DETAIL = <<~CHECK_D
      memo check: メモフォルダの中について、ファイル名が重複しているものを表示するコマンド

      使い方: memo check
          - 引数は取らない
    CHECK_D
    LIST_DETAIL = <<~LIST_D
      memo list: メモフォルダの中のディレクトリとその中にあるファイル名を出力するコマンド

      使い方:
      1. memo list
          - 引数を取らなければ、メモフォルダの中の全てのディレクトリと、その中にあるファイル名を出力する
      2. memo list [DIRS]
          - 引数として、メモフォルダの中にあるディレクトリ名を取ると、そのディレクトリの配下のファイル名を出力する

      2.の例:
        memo list git/ # git/配下のファイル名を表示する
        memo list git  # スラッシュはあってもなくてもいい
    LIST_D
    READ_DETAIL = <<~READ_D
      memo read: メモフォルダの中のファイルを全文表示するコマンド

      使い方: memo read FILE_NAME
          - ファイル名は必須

      なお、メモフォルダに同じ名前のファイルが二つ以上存在する場合は、
      その中からどのファイルを表示するかを選択するためのプロンプトが表示される。
    READ_D
    SEARCH_DETAIL = <<~SEARCH_D
      memo search: メモフォルダの中の全てのファイルを対象に、文字列の検索を行うコマンド

      使い方: memo search SEARCH_WORD
          - 検索文字列は必須
    SEARCH_D
    DIRS_DETAIL = <<~DIRS_D
      memo dirs: メモフォルダの中のディレクトリの一覧を表示するコマンド

      使い方: memo dirs
          - 引数は取らない

      config/config.ymlで設定したフォルダごとに、ディレクトリを出力する
    DIRS_D
    TAG_DETAIL = <<~TAG_D
      memo tag: 引数として受け取ったタグの情報を表示するコマンド

      使い方: memo tag TAG_NAME
          - タグ名は必須
    TAG_D
    LIST_OPTIONS_DUPLICATE = '重複するファイル名のメモの一覧を表示する'
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
    VERSION_DETAIL = <<~VERSION_D
      memo version: memo CLIのバージョンを表示するコマンド

      使い方: memo version
          - 引数は取らない
    VERSION_D
  end
end
