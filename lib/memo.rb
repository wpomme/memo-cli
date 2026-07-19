# frozen_string_literal: true

# TODO: importの命名規則を調べておきたい
# TODO: import順でテストが動かなくなる時がある
require_relative "memo/memo_file_utility"
require_relative "memo/options/parser"
require_relative "memo/Struct"
require_relative "memo/Repository"
require_relative "memo/view_model"
require_relative "memo/Presenter"
require_relative "memo/command"

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
