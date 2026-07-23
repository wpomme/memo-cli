# frozen_string_literal: true

module Memo
  class Command
    def self.run(argv)
      new.execute(argv)
    end

    def execute(argv)
      options = Memo::SubCommandParser.parse!(argv)

      case options.shift
      when :list
        View.list(options.shift)
      when :dirs
        View.dirs
      when :read
        View.read(options.shift)
      end
    end
  end
end
