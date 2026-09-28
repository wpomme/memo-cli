# frozen_string_literal: true

require 'yaml'

module Memo
  module Config
    CONFIG_PATH = File.expand_path("../../config/config.yml", __dir__)
    NEW_CONFIG_PATH = File.expand_path("../../config/new_config.yml", __dir__)

    class << self
      def memo_dir
        load if @config.nil?

        File.join(Dir.home, @config["memo_dir"])
      end

      def target_dirs
        load if @new_config.nil?

        @new_config["target_dirs"].map do |dir|
          File.join(Dir.home, dir)
        end
      end

      def load(config_path = CONFIG_PATH)
        @config = YAML.load_file(config_path)
        @new_config = YAML.load_file(NEW_CONFIG_PATH)
      end

      private_class_method :load
    end
  end
end
