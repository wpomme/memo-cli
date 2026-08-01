# frozen_string_literal: true

require 'yaml'

module Memo
  module Config
    CONFIG_PATH = File.expand_path("../../config/config.yml", __dir__)

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
