# frozen_string_literal: true

require 'yaml'

## TODO: WIP
module Memo
  class Config
    def self.memo_dir(memo_dir = nil)
      new
      return memo_dir if ENV.fetch('MEMO_CLI_RUNTIME_ENV') == 'test'

      File.join(Dir.home, @memo_dir)
    end

    def initialize
      config_path = File.expand_path("../../config/config.yml", __dir__)
      config = YAML.load_file(config_path)

      @memo_dir = config[memo_dir]
    end
  end
end
