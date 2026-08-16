# frozen_string_literal: true

module Memo
  class View
    NOT_FOUND_MESSAGE = "wordというメモは見つかりませんでした。"
    MULTIPLE_FOUND_MESSAGE = "メモがsize件あります。"
    include Memo::Service

    def initialize(repo)
      @repo = repo
      @mapper = Memo::Mapper.new(repo)
    end

    def dirs
      puts @mapper.colored_dirs
    end

    def read(word)
      found = @repo.find(word)
      ## TODO: とりあえずの修正
      return puts @repo.read(found.first) if found.size == 1

      if found.size > 1
        choices = found.to_h { |seed| [seed.rel_path, seed] }
        choice = select_prompt(title: MULTIPLE_FOUND_MESSAGE.sub("size", found.size.to_s), choices: choices)
        puts @repo.read(choice)
      else
        puts NOT_FOUND_MESSAGE.sub("word", word)
        exit(2)
      end
    end

    def list(dir = nil)
      puts @mapper.file_list_to_view(dir)
    end

    def search(word)
      puts @mapper.search_result_to_view(word)
    end
  end
end
