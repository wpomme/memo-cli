# frozen_string_literal: true

module Memo
  class Command
    def run(argv)
      execute(argv)
    end

    private

    def execute(argv)
      options = Memo::SubCommandParser.new.run(argv).to_a.flatten

      Memo::CommandView.new.public_send(options.shift, word: options.shift)
    end
  end
end
