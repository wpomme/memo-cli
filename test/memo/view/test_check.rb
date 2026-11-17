# frozen_string_literal: true

require_relative '../../helper'

class TestViewCheck < Minitest::Test
  include Memo::Message

  describe 'View::Check' do
    def setup
      @view = Memo::View::Check.new
    end

    describe '#check' do
      it 'ViewModelはexecuteメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:execute)
      end
    end
  end
end
