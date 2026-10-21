# frozen_string_literal: true

# require_relative '../../helper'

class TestViewRead < Minitest::Test
  describe 'View::Read' do
    describe '#run' do
      it '見つからなかった場合' do
        search_word = 'does_not_exist_files'

        actual = Memo::View::Read.run(search_word)

        expected = 0

        _(actual.size).must_equal(expected)
      end

      it '一件見つかった場合' do
        search_word = 'ls'

        actual = Memo::View::Read.run(search_word)

        expected = 1

        _(actual.size).must_equal(expected)
      end
      it '複数件見つかった場合は、choicesを返して、viewに処理を任せる' do
        search_word = 'diff'

        actual = Memo::View::Read.run(search_word)

        expected = 2

        _(actual.size).must_equal(expected)
      end
    end
  end
end
