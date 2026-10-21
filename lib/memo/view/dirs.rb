# frozen_string_literal: true

module Memo
  module View
    class Dirs
      def self.run
        new.execute
      end

      def execute
        Memo::DirectoryLoader.new.relative_path_hash.transform_values { |paths| paths.join("\n") }
          .map do |key, value|
            [Rainbow("#{key}:").green].push(value).push('')
          end
      end
    end
  end
end
