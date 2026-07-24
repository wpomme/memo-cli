# frozen_string_literal: true

module Memo
  class Command
    def self.run(memo_dir, argv)
      new(memo_dir).execute(argv)
    end

    def initialize(dir)
      @memo_dir = dir
    end

    def execute(argv)
      options = Memo::SubCommandParser.parse!(argv)

      view = View.new(@memo_dir)

      case options.shift
      when :list
        view.list(options.shift)
      when :dirs
        view.dirs
      when :read
        view.read(options.shift)
      end
    end
  end
end
