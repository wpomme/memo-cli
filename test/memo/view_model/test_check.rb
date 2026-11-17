# frozen_string_literal: true

require_relative '../../helper'

class TestViewModelCheck < Minitest::Test
  describe 'ViewModel::Check' do
    include MemoLifecycleHooks
    include Memo::ViewModel

    def setup
      super
      @vm = Memo::ViewModel::Check.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe 'Checkクラス' do
      it 'CheckはMemo::ViewModelをインクルードしていること' do
        actual = Memo::ViewModel::Check.include?(Memo::ViewModel)

        _(actual).must_equal(true)
      end
    end

    describe '#execute' do
      it '重複するファイル名がある場合、Arrayを返すこと' do
        actual = @vm.execute

        _(actual).must_be_instance_of(Array)
      end

      it '重複するファイル名がある場合、結果が空でないこと' do
        actual = @vm.execute

        _(actual).wont_be_empty
      end

      it '重複するファイル名のファイルが含まれていること' do
        actual = @vm.execute

        _(actual).must_include(@fixed_duplicated_filename)
      end
    end
  end
end
