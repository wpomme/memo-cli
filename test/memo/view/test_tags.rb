# frozen_string_literal: true

require_relative '../../helper'

class TestViewTags < Minitest::Test
  describe 'View::Tags' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::Tags.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#run' do
      it '引数がtrueの場合、タグとそれに紐づいたファイルの一覧を出力する' do
        skip 'TODO: それぞれのタグの数が合うかどうかを確かめること。'
        actual = @view.run(true)

        _(actual).wont_be_empty
      end

      it ':nameを受け取った場合、タグ名だけを出力する。FileLoaderのtag_sizeと同じ数であること。' do
        option = :name

        out = @view.run(option)

        actual = out.size

        expected = @file_loader.tag_size

        _(actual).must_equal(expected)
      end

      it ':countを受け取った場合、タグ名とそのタグが付いたファイルの数を出力する。' do
        skip 'TODO: それぞれのタグの数が合うかどうかを確かめること。'
        option = :count

        out = @view.run(option)

        # actual = out.size
        #
        # expected = Memo::FileLoader.new.tag_size

        _(out).wont_be_empty
        # _(actual).must_equal(expected)
      end

      it ':emptyを受け取った場合、タグの付いていないファイル名の一覧を出力する。全てのファイルにタグが付いていれば、ユーザーメッセージを表示する。' do
        skip 'TODO'
        option = :empty

        out = @view.run(option)

        # actual = out.size
        #
        # expected = Memo::FileLoader.new.tag_size

        _(out).wont_be_empty
        # _(actual).must_equal(expected)
      end
    end
  end
end
