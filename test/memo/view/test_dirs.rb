# frozen_string_literal: true

require_relative '../../helper'

class TestViewDirs < Minitest::Test
  describe 'View::Dirs' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::Dirs.new(target_dirs: @test_target_dirs)
    end

    describe 'Dirsクラス' do
      it 'DirsはMemo::Viewをインクルードしていること' do
        actual = Memo::View::Dirs.include?(Memo::View)

        _(actual).must_equal(true)
      end
    end
  end
end
