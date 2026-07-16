# frozen_string_literal: true

# require 'find'
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
      options = Memo::Command::Options::SubCommand.parse!(argv)

      case options.shift
      when :list
        Docs.list(@memo_dir, options.shift)
      when :dirs
        Docs.dirs(@memo_dir)
      when :read
        Docs.read(@memo_dir, options.shift)
      end
    end
  end
end
