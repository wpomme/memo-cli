# frozen_string_literal: true

module Memo
  module View
    class Check
      def initialize
        @vw = Memo::ViewModel::Check.new
      end

      def execute(*)
        @vw.execute.each do |line|
          puts line
        end
      end
    end
  end
end
