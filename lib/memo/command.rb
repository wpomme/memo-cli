# frozen_string_literal: true

require 'find'
require 'memo/docs'

module Memo
  class Command
    def self.run(memo_dir, argv)
      new(memo_dir, argv).execute
    end

    def initialize(memo_dir, argv)
      @memo_dir = memo_dir
      @argv = argv
    end

    def execute
      parsed_options = Options.parse!(@argv)

      case parsed_options.argv.first
      when 'list'
        if parsed_options.argv[1]
          Docs.new(@memo_dir).print_files_by_dir(parsed_options.argv[1])
        else
          Docs.new(@memo_dir).print_files
        end
      when 'dirs'
        Docs.new(@memo_dir).print_dirs
      when 'read'
        Docs.new(@memo_dir).read_and_print_content(parsed_options.argv[1])
      end
    end
  end
end
