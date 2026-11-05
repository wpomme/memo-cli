# frozen_string_literal: true

require_relative '../../helper'

class TestViewDirs < Minitest::Test
  include Memo::Message

  describe 'View::Dirs' do
    def setup
      @view = Memo::View::Dirs.new
    end

    describe '#dirs' do
      it 'ViewModelはexecuteメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:execute)
      end
    end
  end
end
