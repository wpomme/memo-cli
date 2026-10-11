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

        # resultの型をチェックする
        actual_type = result.all? do |directory_path, directory_id|
          FileTest.directory?(directory_path) && directory_id.instance_of?(Integer)
        end

        _(actual).must_equal(expected)
        _(actual_type).must_equal(true)
      end
    end
  end
end
