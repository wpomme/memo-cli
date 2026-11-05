# frozen_string_literal: true

module Memo
  class Command
    def run(argv)
      execute(argv)
    end

    private

    def execute(argv)
      options = Memo::SubCommandParser.new.run(argv).to_a.flatten

      klass = Object.const_get("Memo::View::#{options.shift.capitalize}")
      klass.new.run(word: options.shift)
    end
  end
end
