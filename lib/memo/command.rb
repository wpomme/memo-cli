# frozen_string_literal: true

module Memo
  class Command
    def self.run(memo_dir, argv)
      new(memo_dir).execute(argv)
    end

    def initialize(memo_dir)
      @memo_dir = memo_dir
    end

    def execute(argv)
      options = Memo::SubCommandParser.parse!(argv)

      case options.shift
      when :list
        View.list(@memo_dir, options.shift)
      when :dirs
        View.dirs(@memo_dir)
      when :read
        View.read(@memo_dir, options.shift)
      end
    end
  end
end
