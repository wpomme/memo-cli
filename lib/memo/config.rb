# frozen_string_literal: true

require 'yaml'

## TODO: WIP
module Memo
  module Config
    CONFIG_PATH = File.expand_path("../../config/config.yml", __dir__)
    # テスト環境ではMemo::Config.memo_dirは使わず、直接@test_memo_dirに対象のディレクトリを保存すればいい
    # それ以外の環境ではMemo::Config.memo_dirを使う
    class << self
      def memo_dir
        load if @config.nil?

        File.join(Dir.home, @config["memo_dir"])
      end

      def load(config_path = CONFIG_PATH)
        @config = YAML.load_file(config_path)
      end

      private_class_method :load
    end
  end
end
