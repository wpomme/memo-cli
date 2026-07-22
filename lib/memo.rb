# frozen_string_literal: true

# TODO: importの命名規則を調べておきたい
# TODO: import順でテストが動かなくなる時がある
require_relative "memo/file_utility"
require_relative "memo/message"
require_relative "memo/sub_command_parser"
require_relative "memo/model"
require_relative "memo/repository"
require_relative "memo/mapper"
require_relative "memo/view"
require_relative "memo/command"
# require_relative "memo/mock_seed"

# memoディレクトリのトップモジュール
#
# VERSIONとMemoの環境変数Memo::Envはこちらに記載している
module Memo
  class Error < StandardError; end
  VERSION = "0.1.0"

  # テストの実行か、exe/memoの実行かで環境変数を設定する
  # MEMO_CLI_RUNTIME_ENV = 'test' | 'exe'
  # この値に従って、memo_dirの場所を変える
  module Env
    # HOMEディレクトリからの相対パスを使う
    # TODO: 隠しファイルかRakefileあたりからパスを読み込めたらいいと思う
    MEMO_DIR = "/repo/memorandum/memo"

    def self.to_memo_dir
      File.join(Dir.home, MEMO_DIR)
    end
  end
end
