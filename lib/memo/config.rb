# frozen_string_literal: true

module Memo
  module Config
    CONFIG_PATH = File.expand_path('../../config/config.yml', __dir__)

    class << self
      def target_dirs
        load if @config.nil?

        @config['target_dirs'].map do |dir|
          File.join(Dir.home, dir)
        end
      end

      def load(config_path = CONFIG_PATH)
        @config = YAML.load_file(config_path)
      end

      private_class_method :load
    end
  end
end
