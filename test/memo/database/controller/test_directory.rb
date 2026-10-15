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

      it('全てのデータを挿入した場合、対象のディレクトリと同じ数の配列が戻り値となること') do
        config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
        directory_dataset = Memo::Database::Controller::Directory.new

        config_directory_seeds_result = config_directory_dataset.seeds

        result = directory_dataset.seeds(config_directory_seeds_result)

        actual = result.size
        expected = Memo::Database::Service.rel_paths_size

        # resultの型をチェックする
        actual_type = result.all? do |directory_path, directory_id|
          directory_path.instance_of?(String) && directory_id.instance_of?(Integer)
        end

        _(actual).must_equal(expected)
        _(actual_type).must_equal(true)
      end
    end
  end
end
