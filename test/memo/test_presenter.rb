# frozen_string_literal: true

require_relative "../test_helper"

class TestPresenter < Minitest::Test
  describe 'Presenter' do
    include MemoTestLifecycleHooks

    describe '#dirs' do
      it "memoの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::Presenter.dirs(@memo_dir)
        end

        # 順番が異なっていても、書き出す内容が同じなら問題ない
        assert_equal @dir_set, out.split("\n").to_set
      end
    end

    describe '#read' do
      it 'wordが存在するファイルと一致するとき、そのファイルを全文表示する' do
        out, = capture_io do
          Memo::Presenter.read(@memo_dir, "find")
        end

        assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
      end

      it 'wordが存在しないファイルの場合は、そのwordにあたるメモはないことを表示する' do
        word = 'invalid_memo'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::Presenter.read(@memo_dir, word)
          end

          assert_equal 2, exception.status
        end

        assert_equal "#{word} というメモは見つかりませんでした。\n", out
      end
    end
  end
end
