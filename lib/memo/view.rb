# frozen_string_literal: true

module Memo
  class View
    def initialize(repo)
      @repo = repo
      @mapper = Memo::Mapper.new(repo)
    end

    def dirs
      puts @mapper.colored_dirs
    end

    def read(word)
      found = @repo.find(word)
      return puts @repo.read(found) if found

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    def list(dir = nil)
      puts Memo::Mapper.new(@repo).file_list_to_view(dir)
    end
  end
end
