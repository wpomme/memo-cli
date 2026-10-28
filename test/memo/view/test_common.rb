# frozen_string_literal: true

require_relative '../../helper'

class TestViewCommon < Minitest::Test
  describe 'Memo::View' do
    include MemoLifecycleHooks

    def setup
      super
      @view_module = Memo::View
    end

    describe 'Common' do
      it 'Memo::Viewモジュールはremove_last_elementメソッドを返す' do
        actual = @view_module.method_defined?(:remove_last_element)

        _(actual).must_equal(true)
      end

      it 'Memo::ViewモジュールはCOLOR_METHODSのキーと同じ名前のメソッドを返す' do
        actual = @view_module::COLOR_METHODS.keys.all? do |meth|
          @view_module.method_defined?(meth)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
