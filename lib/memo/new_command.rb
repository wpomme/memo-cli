# frozen_string_literal: true

module Memo
  class NewCommand
    def self.run(argv)
      new.execute(argv)
    end

    def execute(argv)
      options = Memo::NewSubCommandParser.run(argv).to_a.flatten

      Memo::NeoView.new.public_method(options.shift).call(options.shift)
    end
  end
end
