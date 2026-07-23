# frozen_string_literal: true

module Memo
  class View
    def initialize(dir = Memo::Env.memo_dir)
      @memo_dir = dir
    end

    def self.dirs(dir = Memo::Env.memo_dir)
      new(dir)
      puts Memo::Repository.new(dir).to_dirs
    end

    def self.read(word, dir = Memo::Env.memo_dir)
      repo = Memo::Repository.new(dir)
      found = repo.find(word)
      return puts repo.read(found) if found

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    def self.list(word = nil, dir = Memo::Env.memo_dir)
      puts Memo::Mapper.new(dir).file_list_to_view(word)
    end
  end
end
