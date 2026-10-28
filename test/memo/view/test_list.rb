# frozen_string_literal: true

require_relative '../../helper'

class TestViewList < Minitest::Test
  describe 'View::List' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::List.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe 'Listクラス' do
      it 'ListはMemo::Viewをインクルードしていること' do
        actual = Memo::View::List.include?(Memo::View)

        _(actual).must_equal(true)
      end
    end

    describe '#run' do
      it '引数がtrueの場合、対象のディレクトリの配列が返ってくる' do
        actual = @view.run(true)

        _(actual).must_be_instance_of(Array)
      end

      it '有効な引数を取る場合、対象のディレクトリの配列が返ってくる' do
        dirname = 'git/'

        actual = @view.run(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '末尾のスラッシュを付けなくても、対象のディレクトリの配列が返ってくる' do
        dirname = 'git'

        actual = @view.run(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '有効な引数を取る場合、対象のディレクトリの配列が返ってくる' do
        dirname = 'lang/'

        actual = @view.run(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '無効な引数を取る場合、nilが返ってくる。後ほどメッセージが返ってくるように修正する' do
        dirname = 'does_not_exist_dirname'

        actual = @view.run(dirname)

        _(actual).must_be_nil
      end
    end
  end
end
