# frozen_string_literal: true

require_relative "../test_helper"

class TestPresenter < Minitest::Test
  describe 'Presenter' do
    include MemoTestLifecycleHooks

    describe '#dirs' do
      it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::Presenter.dirs(@memo_dir)
        end

        # 順番が異なっていても、書き出す内容が同じなら問題ない
        assert_equal @dir_set, out.split("\n").to_set
      end
    end
  end
end
