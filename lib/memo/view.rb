# frozen_string_literal: true

module Memo
  class View
    def self.dirs
      puts Memo::Repository.new.to_dirs
    end

    def self.read(word)
      found = Memo::Repository.new.find(word)
      return puts Memo::Repository.new.read(found) if found

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    def self.list(word = nil)
      puts Memo::Mapper.file_list_to_view(word)
    end
  end
end
