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
          @vw.default.each do |target_dir, seed_hash|
            puts dir_color_sub(target_dir)

            seed_hash.each do |dir, seeds|
              puts dir_color_main(dir)

              filenames = seeds.map do |seed|
                seed[:filename]
              end

              puts filenames.join(SPACE)
              # TODO: 最後の要素だけは改行を出力しないようにしたい
              puts
            end
          end
        else
          puts @vw.execute(word)
        end
      end
    end
  end
end
