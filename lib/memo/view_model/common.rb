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

    COLOR_METHODS.each do |meth, cnst|
      define_method(meth, lambda do |str|
        Rainbow(str).color(cnst)
      end)
    end

    # 対象ディレクトリ=>親ディレクトリ=>ファイル名
    # というパターンの表示をユーザー向けに行うメソッド
    def seeds_grouped_by_directory_to_view(grouped_seeds)
      grouped_seeds.map do |target_dir, seed_hash|
        lines = seed_hash.map do |dir, seeds|
          filenames = seeds.map { |s| s[:filename] }.join(SPACE)
          "#{dir_color_main(dir)}\n#{filenames}"
        end
        "#{dir_color_sub(target_dir)}\n#{lines.join("\n\n")}"
      end.join("\n\n\n")
    end
  end
end
