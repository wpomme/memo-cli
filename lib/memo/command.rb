# frozen_string_literal: true

require_relative 'docs'
require_relative 'presenter'

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
        Presenter.dirs(@memo_dir)
      when :read
        Presenter.read(@memo_dir, options.shift)
      end
    end
  end
end
