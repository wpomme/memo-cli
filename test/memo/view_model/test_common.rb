# frozen_string_literal: true

require_relative '../../helper'

class TestViewCommon < Minitest::Test
  describe 'Memo::ViewModel' do
    include MemoLifecycleHooks

    def setup
      super
      @vm = Memo::ViewModel
    end

    describe 'Common' do
      it 'Memo::ViewModelモジュールはremove_last_elementメソッドを返す' do
        actual = @vm.method_defined?(:remove_last_element)

        _(actual).must_equal(true)
      end

      it 'Memo::ViewModelモジュールはCOLOR_METHODSのキーと同じ名前のメソッドを返す' do
        actual = @vm::COLOR_METHODS.keys.all? do |meth|
          @vm.method_defined?(meth)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
