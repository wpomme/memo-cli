# frozen_string_literal: true

module Memo
  class Command
    def self.run(argv)
      new.execute(argv)
    end

    def execute(argv)
      options = Memo::SubCommandParser.run(argv).to_a.flatten

      Memo::CommandView.new.public_method(options.shift).call(options.shift)
    end
  end
end
