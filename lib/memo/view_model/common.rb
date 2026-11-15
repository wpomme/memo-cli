# frozen_string_literal: true

module Memo
  module ViewModel
    SPACE = ' '

    DIR_COLOR_MAIN = :green
    DIR_COLOR_SUB = :cyan
    TAG_COLOR = :aqua

    COLOR_METHODS = {
      dir_color_main: DIR_COLOR_MAIN,
      dir_color_sub: DIR_COLOR_SUB,
      tag_color: TAG_COLOR
    }.freeze

    def remove_last_element(arr)
      arr.pop
      arr
    end

    COLOR_METHODS.each do |meth, cnst|
      define_method(meth, lambda do |str|
        Rainbow(str).color(cnst)
      end)
    end

    # 対象ディレクトリ=>親ディレクトリ=>ファイル名
    # というパターンの表示をユーザー向けに行うメソッド
    def seeds_grouped_by_directory_to_view(grouped_seeds)
      result = []

      grouped_seeds.each do |target_dir, seed_hash|
        result << dir_color_sub(target_dir)

        seed_hash.each do |dir, seeds|
          filenames = seeds.map { |s| s[:filename] }.join(SPACE)
          result << dir_color_main(dir) << filenames << "\n"
        end
      end

      remove_last_element(result)
    end
  end
end
