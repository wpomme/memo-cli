# frozen_string_literal: true

module Memo
  module View
    class Check
      def initialize(target_dirs: Memo::Config.target_dirs)
        @vw = Memo::ViewModel::Check.new(target_dirs: target_dirs)
      end

      def execute(*)
        puts @vw.execute
      end
    end
  end
end
