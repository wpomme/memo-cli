# frozen_string_literal: true

module Memo
  class View
    def self.dirs(memo_dir)
      puts Memo::Repository.new(memo_dir).to_dirs
    end

    def self.read(memo_dir, word)
      found = Memo::Repository.new(memo_dir).find(word)
      return puts Memo::Repository.read(found) if found

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    def self.list(memo_dir, word = nil)
      puts Memo::Mapper.file_list_to_view(memo_dir, word)
    end
  end
end
