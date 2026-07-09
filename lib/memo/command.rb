# frozen_string_literal: true

require 'find'
require 'memo/docs'

module Memo
  class Command
    def self.run(memo_dir, argv)
      new(memo_dir).execute(argv)
    end

    def initialize(memo_dir)
      @memo_dir = memo_dir
    end

    def execute(argv)
      # parsed_options = Options.parse!(@argv)
      parsed_options = Memo::Command::Options::SubCommand.parse!(argv)

      case parsed_options.first
      when :list
        if parsed_options[1]
          Docs.new(@memo_dir).print_files_by_dir(parsed_options.pop)
        else
          Docs.new(@memo_dir).print_files
        end
      when :dirs
        Docs.new(@memo_dir).print_dirs
      when :read
        Docs.new(@memo_dir).read_and_print_content(parsed_options.pop)
      end
    end
  end
end
