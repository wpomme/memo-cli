# frozen_string_literal: true

module Memo
  class CommandView
    def read(word:)
      puts read_file_by_found_result(word)
    end

    def search(word:)
      puts Memo::View::Search.run(word)
    end

    def tag(word:)
      puts Memo::View::Tag.run(word)
    end

    def dirs(_)
      puts Memo::View::Dirs.run
    end

    def list(word: '')
      puts Memo::View::List.run(word)
    end

    def tags(word: '')
      puts Memo::View::Tags.run(word)
    end

    private

    def read_file_by_found_result(word)
      found = Memo::View::Read.run(word)
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
