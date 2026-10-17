# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:directories].delete
        Memo::Database::DB[:config_directories].delete
        super
      end

      it('全てのデータが挿入できること') do
        directory_dataset = Memo::Database::Controller::Directory.new

        result = directory_dataset.seeds

        actual = result.size
        expected = Memo::Database::Service.rel_paths_size

        _(actual).must_equal(expected)
      end
    end
  end
end
