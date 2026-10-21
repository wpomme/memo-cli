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
  end
end
