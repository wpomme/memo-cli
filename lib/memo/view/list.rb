# frozen_string_literal: true

module Memo
  module View
    class List
      include Memo::View

      def initialize
        @vw = Memo::ViewModel::List.new
      end

      def execute(word: '')
        if word == true
          @vw.default.each do |line|
            puts line
          end
        elsif word == :duplicate
          grouped = @vw.duplicate.group_by do |file_seed|
            file_seed[:filename]
          end

          grouped.each do |filename, seeds|
            colored_dirs = seeds.map.with_index(1) do |seed, index|
              dir_color_sub("[#{index}]: #{seed[:parent_directory]}")
            end
            puts filename
            puts colored_dirs
            # TODO: 最後の要素だけは改行を出力しないようにしたい
            puts SPACE
          end
        else
          puts @vw.execute(word)
        end
      end
    end
  end
end
