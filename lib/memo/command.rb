# frozen_string_literal: true

module Memo
  class Command
    def run(argv)
      execute(argv)
    end

    private

    def execute(argv)
      options = Memo::SubCommandParser.run(argv).to_a.flatten

      Memo::CommandView.new.public_send(options.shift, options.shift)
    end
  end
end
