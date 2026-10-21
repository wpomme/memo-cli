# frozen_string_literal: true

# require_relative '../../helper'

class TestViewTags < Minitest::Test
  describe 'View::Tags' do
    describe '#run' do
      # TODO: それぞれのタグの数が合うかどうかを確かめること。境界値条件
      it '引数がtrueの場合、タグとそれに紐づいたファイルの一覧を出力する' do
        actual = Memo::View::Tags.run(true)

        _(actual).wont_be_empty
      end

      it ':nameを受け取った場合、タグ名だけを出力する。FileLoaderのtag_sizeと同じ数であること。' do
        option = :name

        out = Memo::View::Tags.run(option)

        actual = out.size

        expected = Memo::FileLoader.new.tag_size

        _(actual).must_equal(expected)
      end

      it ':countを受け取った場合、タグ名とそのタグが付いたファイルの数を出力する。' do
        option = :count

        out = Memo::View::Tags.run(option)

        # actual = out.size
        #
        # expected = Memo::FileLoader.new.tag_size

        _(out).wont_be_empty
        # _(actual).must_equal(expected)
      end
    end
  end
end
