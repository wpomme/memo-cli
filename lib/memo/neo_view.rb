# frozen_string_literal: true

module Memo
  class NeoView
    def read(word)
      puts read_file_by_found_result(word)
    end

    def search(word)
      puts Memo::NewView::Search.run(word)
    end

    def tag(word)
      puts Memo::NewView::Tag.run(word)
    end

    def dirs(_)
      puts Memo::NewView::Dirs.run
    end

    private

    def read_file_by_found_result(word)
      found = Memo::NewView::Read.run(word)
      size = found.size

      return Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word) if size.zero?

      return found[0][:file_content] if size == 1

      read_prompt(found)
    end

    def read_prompt(found)
      choices = found.to_h { |file_seed| [file_seed[:parent_directory], file_seed] }
      choice = Memo::Service.select_prompt(title: Memo::Message::MULTIPLE_MEMOS_WEWE_FOUND.sub('size', found.size.to_s), choices: choices)
      choice.values.flatten
    end
  end
end
