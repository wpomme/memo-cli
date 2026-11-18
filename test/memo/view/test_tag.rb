# frozen_string_literal: true

require_relative '../../helper'

class TestViewTag < Minitest::Test
  describe 'View::Tag' do
    include MemoLifecycleHooks
    include Memo::Message

    def setup
      super
      @view = Memo::View::Tag.new(target_dirs: @test_target_dirs)
      @vw = Memo::ViewModel::Tag.new(target_dirs: @test_target_dirs)
    end

    describe '#tag' do
      it '検索結果が見つかった場合、所定の値を標準出力に出すこと' do
        word = 'CLI'

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.execute(word)

        _(actual).must_equal(expected << "\n")
      end

      it '検索結果が見つからなかった場合、所定の値を標準出力に出すこと' do
        word = 'does_not_exist_word'

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.execute(word)

        _(actual).must_equal(expected << "\n")
      end
    end
  end
end
