# frozen_string_literal: true

module Memo
  module Message
    HELP_COMMANDS = %w[-h --help help].freeze
    HELP_MESSAGE = <<~HELP
      Usage:
      # メモの一覧を表示する
      memo list

      # そのディレクトリの中になるメモの一覧を表示する
      memo list <dirs>

      # 該当のメモを全文表示する
      memo read <word>

      # メモのフォルダ一覧を表示する
      memo dirs
    HELP
  end
end
