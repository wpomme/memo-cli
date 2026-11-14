# frozen_string_literal: true

require_relative '../../helper'

class TestViewTags < Minitest::Test
  include Memo::Message

  describe 'View::Tags' do
    def setup
      @view = Memo::View::Tags.new
    end

    describe '#tags' do
      it 'ViewModelはexecuteメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:execute)
      end

      it 'trueを取る場合' do
        out, = capture_io do
          @view.execute(word: true)
        end

        _(out).wont_be_empty
      end

      it ':emptyを取る場合' do
        out, = capture_io do
          @view.execute(word: :empty)
        end

        _(out).wont_be_empty
      end

      it ':nameを取る場合' do
        out, = capture_io do
          @view.execute(word: :name)
        end

        _(out).wont_be_empty
      end

      it ':countを取る場合' do
        out, = capture_io do
          @view.execute(word: :count)
        end

        _(out).wont_be_empty
      end
    end
  end
end
