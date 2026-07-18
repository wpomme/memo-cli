# frozen_string_literal: true

require 'rainbow'

module Memo
  class ViewModel
    def self.file_list_to_presenter(memo_dir)
      ret = Memo::Repository.new(memo_dir).grouped_file_list.map do |struct|
        [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
      end.flatten
      ret.pop
      ret
    end
  end
end
