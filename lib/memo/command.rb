# frozen_string_literal: true

module Memo
  class Command
    def execute(argv)
      options = Memo::SubCommandParser.new.execute(argv).to_a.flatten

      klass = Object.const_get("Memo::View::#{options.shift.capitalize}")
      klass.new.execute(word: options.shift)
    end
  end
end
