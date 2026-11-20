# frozen_string_literal: true

require_relative '../../helper'

class TestViewTags < Minitest::Test
  describe 'View::Tags' do
    include MemoLifecycleHooks
    include Memo::Message

    def setup
      super
      @view = Memo::View::Tags.new(target_dirs: @test_target_dirs)
      @vw = Memo::ViewModel::Tags.new(target_dirs: @test_target_dirs)
    end

    describe '#default' do
      it '所定の値を標準出力に返すこと' do
        actual, = capture_io do
          # TODO: SubCommandParserの方でtrue => nilに修正する
          @view.execute(word: true)
        end

        expected = @vw.default

        _(actual).must_equal(expected << "\n")
      end
    end

    describe '#count' do
      it '所定の値を標準出力に返すこと' do
        sym = :count
        actual, = capture_io do
          @view.execute(word: sym)
        end

        expected = @vw.send(sym).join("\n")

        _(actual).must_equal(expected << "\n")
      end
    end

    describe '#name' do
      it '所定の値を標準出力に返すこと' do
        sym = :name
        actual, = capture_io do
          @view.execute(word: sym)
        end

        expected = @vw.send(sym).join("\n")

        _(actual).must_equal(expected << "\n")
      end
    end

    describe '#empty' do
      it '所定の値を標準出力に返すこと' do
        sym = :empty
        actual, = capture_io do
          @view.execute(word: sym)
        end

        expected = @vw.send(sym)

        _(actual).must_equal(expected << "\n")
      end
    end
  end
end
