# frozen_string_literal: true

require_relative '../../helper'

class TestViewTags < Minitest::Test
  include Memo::Message

  describe 'View::Tags' do
    def setup
      @view = Memo::View::Tags.new
    end

    describe '#tags' do
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

      it ':nameを取る場合' do
        out, = capture_io do
          @view.run(word: :name)
        end

        _(out).wont_be_empty
      end

      it ':countを取る場合' do
        out, = capture_io do
          @view.run(word: :count)
        end

        _(out).wont_be_empty
      end
    end
  end
end
