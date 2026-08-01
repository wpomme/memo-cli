# frozen_string_literal: true

module Memo
  class Command
    def self.run(argv)
      new(Memo::Repository.new(Memo::Config.memo_dir)).execute(argv)
    end

    def initialize(repo)
      @repo = repo
    end

    def execute(argv)
      options = Memo::SubCommandParser.parse!(argv)

      view = View.new(@repo)

      case options.shift
      when :list
        view.list(options.shift)
      when :dirs
        view.dirs
      when :read
        view.read(options.shift)
      when :search
        view.search(options.shift)
      end
    end
  end
end
