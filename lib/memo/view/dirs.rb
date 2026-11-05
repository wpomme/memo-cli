# frozen_string_literal: true

module Memo
  module View
    class Dirs
      def execute(*)
        puts Memo::ViewModel::Dirs.new.execute
      end
    end
  end
end
