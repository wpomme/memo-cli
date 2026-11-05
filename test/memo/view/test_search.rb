# frozen_string_literal: true

require_relative '../../helper'

class TestView < Minitest::Test
  include Memo::Message

  describe 'View' do
    def setup
      @view = Memo::View::Search.new
    end

    describe '#search' do
      it 'View::Searchはexecuteメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:execute)
      end

      it '検索結果が見つかった場合' do
        search_word = 'ls'

        out, = capture_io do
          @view.execute(word: search_word)
        end

        _(out).wont_be_empty
      end

      it '検索結果が見つからなかった場合' do
        search_word = 'does_not_exist_word'

        out, = capture_io do
          @view.execute(word: search_word)
        end

        expected = NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word) << "\n"

        _(out).must_equal(expected)
      end
    end
  end
end
