# frozen_string_literal: true

module Memo
  module Env
    # HOMEディレクトリからの相対パスを使う
    MEMO_DIR = "/repo/memorandum/memo"

    def self.memo_dir(dir = MEMO_DIR)
      File.join(Dir.home, dir)
    end
  end
end
