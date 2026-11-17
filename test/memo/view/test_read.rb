# frozen_string_literal: true

require_relative '../../helper'

class TestViewRead < Minitest::Test
  describe 'View::Read' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::Read.new(target_dirs: @test_target_dirs)
      @vw = Memo::ViewModel::Read.new(target_dirs: @test_target_dirs)
    end

    describe '#read' do
      it 'ViewModelはexecuteメソッドを返す' do
        actual = @view

        _(actual).must_respond_to(:execute)
      end

      it 'ファイルが見つからない場合は、該当のメモがないことを示すメッセージを表示する' do
        word = 'does_not_exist_files'

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.execute(word)

        _(actual).must_equal(expected << "\n")
      end

      it 'ファイルが一件見つかったとき、そのファイルを全文表示する' do
        word = 'ls'

        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.execute(word)

        _(actual).must_equal(expected)
      end

      it 'ファイルが複数件と一致するとき、どのファイルを表示するかのプロンプトを表示し、選択したファイルを全文表示する' do
        skip 'TODO'
        word = 'diff'

        count = 2

        # 最後の方を選択する
        $stdin = StringIO.new("#{count}\n")
        actual, = capture_io do
          @view.execute(word: word)
        end

        expected = @vw.execute(word)

        _(actual).must_equal(expected)
      ensure
        $stdin = STDIN
      end
    end
  end
end
