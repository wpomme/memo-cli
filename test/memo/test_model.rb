# frozen_string_literal: true

require_relative "../helper"

class TestModel < Minitest::Test
  describe 'Model' do
    include MemoTestLifecycleHooks

    describe '#DirSeed' do
      it 'dir: aaa/bbb/cccのようなディレクトリのparent_dirはbbbとなる' do
        dir = 'aaa/bbb/ccc'
        target_dir_seed = Memo::Model::DirSeed.new(dir, @test_memo_dir)
        _(target_dir_seed.parent_dir).must_equal("bbb")
      end
    end
  end
end
