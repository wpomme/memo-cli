# frozen_string_literal: true

require_relative '../../../helper'

class TestTag < Minitest::Test
  describe('Controller::Tag') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:tags].delete
        super
      end

      it('全てのデータを挿入した場合、IDとタグ名のハッシュが戻り値となること') do
        dataset = Memo::Database::Controller::Tag.new
        result = dataset.seeds

        actual = result.size

        file_loader = Memo::Database::FileLoader.new
        expected = file_loader.all_tag_count_of_list

        _(actual).must_equal(expected)
      end
    end
  end
end
