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

        config_directory_dataset.seeds
        directory_dataset.seeds
        result = file_dataset.seeds

        actual = result.size

        file_loader = Memo::Database::FileLoader.new
        expected = file_loader.file_list_size

        _(actual).must_equal(expected)
      end
    end

    describe('#all') do
      def setup
        dataset = Memo::Database::Controller::File.new

        # データを挿入する
        dataset.seeds
      end

      it('挿入したデータが取得でき、その総数が対象となるファイルの総数と同じであること') do
        dataset = Memo::Database::Controller::File.new

        result = dataset.all

        actual = result.size
        file_loader = Memo::Database::FileLoader.new
        expected = file_loader.file_list_size

        _(actual).must_equal(expected)
      end
    end
  end
end
