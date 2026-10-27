# frozen_string_literal: true

require_relative '../../helper'

class TestViewRead < Minitest::Test
  describe 'View::Read' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::Read.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#run' do
      it '見つからなかった場合' do
        search_word = 'does_not_exist_files'

        actual = @view.run(search_word)

        expected = 0

        _(actual.size).must_equal(expected)
      end

      it '一件見つかった場合' do
        search_word = 'ls'

        actual = @view.run(search_word)

        expected = 1

        _(actual.size).must_equal(expected)
      end
      it '複数件見つかった場合は、choicesを返して、viewに処理を任せる' do
        search_word = 'diff'

        actual = @view.run(search_word)

        expected = 2

        _(actual.size).must_equal(expected)
      end
    end
  end
end
