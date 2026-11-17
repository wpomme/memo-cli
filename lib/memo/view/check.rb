# frozen_string_literal: true

module Memo
  module View
    class Check
      def initialize
        @vw = Memo::ViewModel::Check.new
      end

      def execute(*)
        puts @vw.execute
      end
    end
  end
end
