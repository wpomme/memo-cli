# frozen_string_literal: true

module Memo
  class Command
    DISPATCH = {
      dirs: 'Dirs',
      list: 'List',
      read: 'Read',
      search: 'Search',
      tag: 'Tag',
      tags: 'Tags'
    }.freeze

    def run(argv)
      execute(argv)
    end

    private

    def execute(argv)
      options = Memo::SubCommandParser.new.run(argv).to_a.flatten

      name = DISPATCH[options.shift]
      klass = Object.const_get("Memo::View::#{name}")
      klass.new.run(word: options.shift)
    end
  end
end
