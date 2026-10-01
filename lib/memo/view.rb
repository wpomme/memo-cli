# frozen_string_literal: true

module Memo
  class View
    def initialize(repo)
      @repo = repo
      @mapper = Memo::Mapper.new(repo)
    end

    def dirs
      puts @mapper.dirs_to_view
    end

    def read(word = '')
      # 引数が与えられていない場合は、その旨をユーザーに知らせるメッセージを返す
      return puts Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'read') if word.empty?

      found = @repo.find(word)

      case found.size
      when 0
        puts Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word)
        exit(2)
      when 1
        puts Memo::Service.read(found.first) if found.size == 1
      when (2...)
        choices = found.to_h { |seed| [seed.rel_path, seed] }
        choice = Memo::Service.select_prompt(title: Memo::Message::MULTIPLE_MEMOS_WEWE_FOUND.sub('size', found.size.to_s), choices: choices)
        puts Memo::Service.read(choice)
      else
        StandardError 'There is something wrong with found.size from Repository.find'
        exit(2)
      end
    end

    def tag(tag = '')
      puts @mapper.tag_and_filenames_by_tag_to_view(tag)
    end

    def tags(filter = '')
      case filter
      when :list
        puts @mapper.tag_list_to_view.gsub("\n", ' ')
      when :empty
        file_list = @mapper.empty_tags_file_list_to_view

        if file_list.empty?
          puts Memo::Message::NO_EMPTY_TAGS_FILE_LIST
        else
          puts file_list
        end
      else
        puts @mapper.tag_and_filenames_to_view
      end
    end

    def list(dir = nil)
      puts @mapper.grouped_ls_to_view(dir)
    end

    def search(word = '')
      puts @mapper.search_result_to_view(word)
    end
  end
end
