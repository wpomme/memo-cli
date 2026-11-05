# frozen_string_literal: true

require_relative '../../helper'

class TestViewDirs < Minitest::Test
  describe 'ViewModel::Dirs' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::ViewModel::Dirs.new(target_dirs: @test_target_dirs)
    end

    describe 'Dirsクラス' do
      it 'DirsはMemo::ViewModelをインクルードしていること' do
        actual = Memo::ViewModel::Dirs.include?(Memo::ViewModel)

        _(actual).must_equal(true)
      end
    end
  end
end
