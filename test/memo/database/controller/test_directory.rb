# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:directories].delete
        super
      end

      it('全てのデータを挿入した場合、対象のディレクトリと同じ数の配列が戻り値となること') do
        dataset = Memo::Database::Controller::Directory.new
        result = dataset.seeds

        actual = result.size
        expected = Memo::Database::Service.absolute_paths.size

        _(actual).must_equal(expected)
      end
    end
  end
end
