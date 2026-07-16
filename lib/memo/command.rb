# frozen_string_literal: true

require 'find'
require_relative 'docs'

module Memo
  class Command
    def self.run(memo_dir, argv)
      new(memo_dir).execute(argv)
    end

    def initialize(memo_dir)
      @memo_dir = memo_dir
    end

    def execute(argv)
      parsed_options = Memo::Command::Options::SubCommand.parse!(argv)

      case parsed_options.first
      when :list
        Docs.list(@memo_dir, parsed_options[1])
      when :dirs
        Docs.dirs(@memo_dir)
      when :read
        Docs.new(@memo_dir).read_and_print_content(parsed_options.pop)
      end
    end
  end
end
