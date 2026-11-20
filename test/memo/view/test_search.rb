# frozen_string_literal: true

require_relative '../../helper'

class TestViewSearch < Minitest::Test
  describe 'View::Search' do
    include MemoLifecycleHooks
    include Memo::Message

    def setup
      super
      @view = Memo::View::Search.new(target_dirs: @test_target_dirs)
      @vw = Memo::ViewModel::Search.new(target_dirs: @test_target_dirs)
    end

    describe '#execute' do
      it '検索結果が見つかった場合、所定の値を標準出力に返すこと' do
        word = 'ls'

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.execute(word).join("\n")

        _(actual).must_equal(expected << "\n")
      end

      it '検索結果が見つからなかった場合、所定の値を標準出力に返すこと' do
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
