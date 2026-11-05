# frozen_string_literal: true

require_relative '../../helper'

class TestViewTag < Minitest::Test
  include Memo::Message

  describe 'View::Tag' do
    def setup
      @view = Memo::View::Tag.new
    end

    describe '#tag' do
      it 'ViewModelはrunメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:run)
      end

      it '検索結果が見つかった場合' do
        search_word = 'CLI'

        out, = capture_io do
          @view.run(word: search_word)
        end

        _(out).wont_be_empty
      end

      it '検索結果が見つからなかった場合' do
        search_word = 'does_not_exist_word'
        tag_list = Memo::FileLoader.new.tags_sorted_by_tag_name

        out, = capture_io do
          @view.run(word: search_word)
        end

        expected = NO_TAGS.sub('tag', search_word) << tag_list.join(' ') << "\n"

        _(out).must_equal(expected)
      end
    end
  end
end
