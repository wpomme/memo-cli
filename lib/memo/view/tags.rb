# frozen_string_literal: true

module Memo
  module View
    class Tags
      include Memo::View

      def initialize
        @vw = Memo::ViewModel::Tags.new
      end

      def execute(word: '')
        if word == :empty
          # NOTE* memo listと同じロジックになった
          @vw.empty.each do |target_dir, seed_hash|
            render_hash = {}

            seed_hash.each do |dir, seeds|
              filenames = seeds.map do |seed|
                seed[:filename]
              end

              render_hash[dir] = filenames.join(SPACE)
            end

            puts dir_color_sub(target_dir)

            render_hash.each do |dir, filenames|
              puts dir_color_main(dir)
              puts filenames
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
