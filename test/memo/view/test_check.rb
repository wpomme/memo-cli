# frozen_string_literal: true

require_relative '../../helper'

class TestViewCheck < Minitest::Test
  describe 'View::Check' do
    include MemoLifecycleHooks
    include Memo::Message

    def setup
      super
      @view = Memo::View::Check.new(target_dirs: @test_target_dirs)
      @vw = Memo::ViewModel::Check.new(target_dirs: @test_target_dirs)
    end

    describe '#execute' do
      it '所定の値を標準出力に返すこと' do
        actual, = capture_io do
          @view.execute
        end

        expected = @vw.execute

        _(actual).must_equal(expected << "\n")
      end
    end
  end
end
