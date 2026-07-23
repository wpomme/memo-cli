# frozen_string_literal: true

module Memo
  class Command
    def self.run(memo_dir, argv)
      new(memo_dir).execute(argv)
    end

    def initialize(dir = Memo::Env.memo_dir)
      @memo_dir = dir
    end

    def execute(argv)
      options = Memo::SubCommandParser.parse!(argv)

      Memo::Repository.new(@memo_dir)

      case options.shift
      when :list
        View.list(options.shift, @memo_dir)
      when :dirs
        View.dirs(@memo_dir)
      when :read
        View.read(options.shift, @memo_dir)
      end
    end
  end
end
