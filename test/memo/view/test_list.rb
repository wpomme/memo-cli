# frozen_string_literal: true

require_relative '../../helper'

class TestViewList < Minitest::Test
  describe 'View::List' do
    include MemoLifecycleHooks
    include Memo::Message

    def setup
      super
      @view = Memo::View::List.new(target_dirs: @test_target_dirs)
      @vw = Memo::ViewModel::List.new(target_dirs: @test_target_dirs)
    end

    describe '#default' do
      it '所定の値を標準出力に返すこと' do
        actual, = capture_io do
          @view.execute(word: true)
        end

        expected = @vw.default

        _(actual).must_equal(expected << "\n")
      end
    end

    describe '#directory' do
      it '有効なディレクトリ名を渡した場合、所定の値を標準出力に返すこと' do
        word = @test_mock_dir

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.directory(word)

        _(actual).must_equal(expected << "\n")
      end

      it '無効なディレクトリ名を渡した場合、所定の値を標準出力に返すこと' do
        word = 'does_not_exist_dirname'

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.directory(word)

        _(actual).must_equal(expected)
      end
    end
  end
end
