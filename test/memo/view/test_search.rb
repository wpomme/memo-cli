# frozen_string_literal: true

require_relative '../../helper'

class TestViewSearch < Minitest::Test
  describe 'View::Search' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::Search.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#run' do
      it '見つからなかった場合' do
        search_word = 'does_not_exist_words'

        actual = @view.run(search_word)

        expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word)

        _(actual).must_equal(expected)
      end

      it '検索結果が見つかった場合' do
        skip 'TODO'
        search_word = 'ls'

        actual = @view.run(search_word)

        _(actual).must_equal(expected)
      end
    end
  end
end
