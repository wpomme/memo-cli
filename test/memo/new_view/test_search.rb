# frozen_string_literal: true

# require_relative '../../helper'

class TestNewViewSearch < Minitest::Test
  describe 'NewView::Search' do
    describe '#run' do
      it '見つからなかった場合' do
        search_word = 'does_not_exist_words'

        actual = Memo::NewView::Search.run(search_word)

        expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word)

        _(actual).must_equal(expected)
      end

      it '検索結果が見つかった場合' do
        skip 'TODO'
        search_word = 'ls'

        actual = Memo::NewView::Search.run(search_word)

        _(actual).must_equal(expected)
      end
    end
  end
end
