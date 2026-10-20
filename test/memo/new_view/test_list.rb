# frozen_string_literal: true

# require_relative '../../helper'

class TestNewViewList < Minitest::Test
  describe 'NewView::List' do
    describe '#run' do
      it '引数がtrueの場合、対象のディレクトリの配列が返ってくる' do
        actual = Memo::NewView::List.run(true)

        _(actual).must_be_instance_of(Array)
      end

      it '有効な引数を取る場合、対象のディレクトリの配列が返ってくる' do
        dirname = 'git/'

        actual = Memo::NewView::List.run(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '末尾のスラッシュを付けなくても、対象のディレクトリの配列が返ってくる' do
        dirname = 'git'

        actual = Memo::NewView::List.run(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '有効な引数を取る場合、対象のディレクトリの配列が返ってくる' do
        dirname = 'lang/'

        actual = Memo::NewView::List.run(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '無効な引数を取る場合、nilが返ってくる。後ほどメッセージが返ってくるように修正する' do
        dirname = 'does_not_exist_dirname'

        actual = Memo::NewView::List.run(dirname)

        _(actual).must_be_nil
      end
    end
  end
end
