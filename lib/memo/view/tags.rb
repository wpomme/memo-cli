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
          @vw.empty.each do |target_dir, seed_hash|
            render_hash = {}

            seed_hash.filter_map do |dir, seeds|
              filenames = seeds.filter_map do |seed|
                seed[:filename] if seed[:tags].empty?
              end

              next if filenames.empty?

              render_hash[dir] = filenames.join(SPACE)
            end

            next if render_hash.empty?

            puts dir_color_sub(target_dir)
            render_hash.each do |dir, filenames|
              puts dir_color_main(dir)
              puts filenames
              # TODO: 最後の要素だけは改行を出力しないようにしたい
              puts SPACE
            end
          end
        else
          puts @vw.execute(word)
        end
      end
    end
  end
end
