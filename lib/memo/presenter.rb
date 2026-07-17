# frozen_string_literal: true

module Memo
  class Presenter
    def self.dirs(memo_dir)
      puts Memo::Repository.new(memo_dir).to_dirs
    end
  end
end
