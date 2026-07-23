# frozen_string_literal: true

# TODO: importの命名規則を調べておきたい
# TODO: import順でテストが動かなくなる時がある
require_relative "memo/env"
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
module Memo
  class Error < StandardError; end
  VERSION = "0.1.0"
end
