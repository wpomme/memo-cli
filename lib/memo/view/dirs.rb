# frozen_string_literal: true

module Memo
  module View
    class Dirs
      def run(_)
        puts Memo::ViewModel::Dirs.new.run
      end
    end
  end
end
