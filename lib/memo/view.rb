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

      case found.size
      when 1
        puts Memo::Service.read(found.first) if found.size == 1
      when (2...)
        choices = found.to_h { |seed| [seed.rel_path, seed] }
        choice = Memo::Service.select_prompt(title: Memo::Message::MULTIPLE_MEMOS_WEWE_FOUND.sub("size", found.size.to_s), choices: choices)
        puts Memo::Service.read(choice)
      else
        puts Memo::Message::NO_MEMOS_WEWE_FOUND.sub("word", word)
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
