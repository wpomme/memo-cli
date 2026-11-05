# frozen_string_literal: true

require_relative '../../helper'

class TestViewVersion < Minitest::Test
  include Memo::Message

  describe 'View::Version' do
    def setup
      @view = Memo::View::Version.new
    end

    describe '#execute' do
      it 'Viewはexecuteメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:execute)
      end

      it 'バージョンを出力し、正常終了する' do
        actual, = capture_io do
          @view.execute
        end

        expected = "#{Memo::VERSION}\n"

        _(actual).must_equal(expected)
      end
    end
  end
end
