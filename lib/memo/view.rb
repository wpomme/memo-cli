# frozen_string_literal: true

module Memo
  class View
    def initialize(dir)
      @memo_dir = dir
    end

    def dirs
      puts Memo::Repository.new(@memo_dir).to_dirs
    end

    def read(word)
      repo = Memo::Repository.new(@memo_dir)
      found = repo.find(word)
      return puts repo.read(found) if found

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    def list(dir = nil)
      puts Memo::Mapper.new(@memo_dir).file_list_to_view(dir)
    end
  end
end
