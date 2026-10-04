# frozen_string_literal: true

module Memo
  class Command
    def self.run(argv)
      new(Memo::Repository.new(Memo::Config.target_dirs)).execute(argv)
    end

    def initialize(repo)
      @repo = repo
    end

    def execute(argv)
      options = Memo::SubCommandParser.parse!(argv).to_a.flatten

      View.new(@repo).public_method(options.shift).call(options.shift)
    end
  end
end
