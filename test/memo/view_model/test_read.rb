# frozen_string_literal: true

require_relative '../../helper'

class TestViewRead < Minitest::Test
  describe 'ViewModel::Read' do
    include MemoLifecycleHooks

    def setup
      super
      @vm = Memo::ViewModel::Read.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#execute' do
      it '見つからなかった場合' do
        search_word = 'does_not_exist_files'

        actual = @vm.execute(search_word)

        expected = 0

        _(actual.size).must_equal(expected)
      end

      it '一件見つかった場合' do
        search_word = 'ls'

        actual = @vm.execute(search_word)

        expected = 1

        _(actual.size).must_equal(expected)
      end
      it '複数件見つかった場合は、choicesを返して、viewに処理を任せる' do
        search_word = 'diff'

        actual = @vm.execute(search_word)

        expected = 2

        _(actual.size).must_equal(expected)
      end
    end
  end
end
