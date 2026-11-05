# frozen_string_literal: true

module Memo
  module View
    class Version
      def execute(*)
        puts Memo::VERSION
      end
    end
  end
end
