# frozen_string_literal: true

require_relative '../../../helper'

class TestFile < Minitest::Test
  describe('Controller::File') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:files].delete
        Memo::Database::DB[:directories].delete
        Memo::Database::DB[:config_directories].delete
        super
      end

      it('全てのデータを挿入した場合、対象のディレクトリと同じ数の配列が戻り値となること') do
        config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
        directory_dataset = Memo::Database::Controller::Directory.new
        file_dataset = Memo::Database::Controller::File.new

        config_directory_seeds_result = config_directory_dataset.seeds

        directory_seeds_result = directory_dataset.seeds(config_directory_seeds_result)

        result = file_dataset.seeds(directory_seeds_result)

        actual_size = result.size

        file_loader = Memo::Database::FileLoader.new
        expected_size = file_loader.file_hash_seeds.size

        # load_filesが呼ばれた回数も一回であることを確認する
        actual_called_count = file_loader.instance_variable_get(:@method_called_count)

        expected_called_count = 1

        # resultの型をチェックする
        actual_type = result.all? do |file_id, file_path|
          file_id.instance_of?(Integer) && FileTest.file?(file_path)
        end

        _(actual_size).must_equal(expected_size)
        _(actual_type).must_equal(true)
        _(actual_called_count).must_equal(expected_called_count)
      end
    end
  end
end
