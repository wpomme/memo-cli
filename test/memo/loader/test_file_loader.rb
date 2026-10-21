# frozen_string_literal: true

require_relative '../../helper'

class TestFileLoader < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Loader::FileLoader') do
    describe('#sorted_tags') do
      it('Tagテーブルを作成するのに必要なタグ名の配列が返されること') do
        sorted_tags = Memo::FileLoader.new.sorted_tags

        actual = sorted_tags.all?(String)

        _(actual).must_equal(true)
      end
    end

    describe('#tag_size') do
      it('整数が返されること') do
        actual = Memo::FileLoader.new.tag_size

        _(actual).must_be_instance_of(Integer)
      end
    end

    describe('#total_tag_size') do
      it('整数が返されること') do
        actual = Memo::FileLoader.new.total_tag_size

        _(actual).must_be_instance_of(Integer)
      end
    end
  end
end
