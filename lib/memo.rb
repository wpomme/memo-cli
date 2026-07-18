# frozen_string_literal: true

# TODO: importの命名規則を調べておきたい
require_relative "memo/options/parser"
require_relative "memo/command"
require_relative "memo/docs"
require_relative "memo/Presenter"
require_relative "memo/Struct"
require_relative "memo/Repository"
require_relative "memo/view_model"

# memoディレクトリのトップモジュール
# MemoCliにすればよかったかも...
#
# VERSIONとMemoの環境変数Memo::Envはこちらに記載している
module Memo
  class Error < StandardError; end
  VERSION = "0.1.0"

  module Env
    # HOMEディレクトリからの相対パスを使う
    # TODO: 隠しファイルかRakefileあたりからパスを読み込めたらいいと思う
    MEMO_DIR = "/repo/memorandum/memo"

    def self.to_memo_dir
      File.join(Dir.home, MEMO_DIR)
    end
  end
end
