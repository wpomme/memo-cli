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
      ## TODO: とりあえずの修正
      return puts @repo.read(found.first) if found.size == 1

      # choices = found.to_h { |seed| [seed.rel_path, seed.full_path] }

      puts "#{word} というメモは見つかりませんでした。"
      exit(2)
    end

    def list(dir = nil)
      puts @mapper.file_list_to_view(dir)
    end

    def search(word)
      puts @mapper.search_result_to_view(word)
    end
  end
end
