# frozen_string_literal: true

require_relative '../../helper'

class TestViewList < Minitest::Test
  include Memo::Message

  describe 'View' do
    def setup
      @view = Memo::View::List.new
    end

    describe '#list' do
      it 'ViewModelはrunメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:run)
      end

      it '引数を取らない場合' do
        out, = capture_io do
          @view.run
        end

        _(out).wont_be_empty
      end

      it '有効な引数を取る場合' do
        word = 'git/'

        out, = capture_io do
          @view.run(word: word)
        end

        _(out).wont_be_empty
      end

      it '無効な引数を取る場合' do
        word = 'does_not_exist_dirname'

        out, = capture_io do
          @view.run(word: word)
        end

        _(out).must_equal("\n")
      end
    end
  end
end
