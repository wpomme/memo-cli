# frozen_string_literal: true

module Memo
  module Env
    # HOMEディレクトリからの相対パスを使う
    MEMO_DIR = "/repo/memorandum/memo"

    def self.memo_dir(memo_dir = MEMO_DIR)
      return memo_dir if ENV.fetch('MEMO_CLI_RUNTIME_ENV') == 'test'

      File.join(Dir.home, memo_dir)
    end
  end
end
