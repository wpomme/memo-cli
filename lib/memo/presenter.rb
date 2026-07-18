# frozen_string_literal: true

module Memo
  class Presenter
    def self.dirs(memo_dir)
      puts Memo::Repository.new(memo_dir).to_dirs
    end

    def self.read(memo_dir, word)
      found = Memo::Repository.new(memo_dir).find(word)
      return puts Memo::Repository.read(found) if found

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    # WIP: listにdirが与えられた時も一応作る
    def self.list(memo_dir)
      puts Memo::ViewModel.file_list_to_presenter(memo_dir)
    end
  end
end
