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

        # resultの型をチェックする
        actual_type = result.all? do |directory_path, directory_id|
          directory_path.instance_of?(String) && (directory_id.instance_of?(Integer) || directory_id.instance_of?(Hash))
        end

        _(actual_type).must_equal(true)
      end
    end
  end
end
