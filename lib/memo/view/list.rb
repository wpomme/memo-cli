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
          # NOTE* memo tags --emptyと同じロジックになった
          @vw.default.each do |target_dir, seed_hash|
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
