# frozen_string_literal: true

module Memo
  module View
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
  end
end
