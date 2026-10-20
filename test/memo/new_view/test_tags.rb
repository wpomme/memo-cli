# frozen_string_literal: true

# require_relative '../../helper'

class TestNewViewTags < Minitest::Test
  describe 'NewView::Tags' do
    describe '#run' do
      # TODO: それぞれのタグの数が合うかどうかを確かめること。境界値条件
      it '引数がtrueの場合、タグとそれに紐づいたファイルの一覧を出力する' do
        actual = Memo::NewView::Tags.run(true)

        _(actual).wont_be_empty
      end

      it ':nameを受け取った場合、タグ名だけを出力する。FileLoaderのtag_sizeと同じ数であること。' do
        option = :name

        out = Memo::NewView::Tags.run(option)

        actual = out.size

        expected = Memo::Loader::FileLoader.new.tag_size

        _(actual).must_equal(expected)
      end
    end
  end
end
