# frozen_string_literal: true

require_relative '../../../helper'

class TestFile < Minitest::Test
  describe('Controller::File') do
    include MemoDBTestLifecycleHooks

    def setup
      config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
      directory_dataset = Memo::Database::Controller::Directory.new
      @file_dataset = Memo::Database::Controller::File.new

      config_directory_dataset.seeds
      directory_dataset.seeds
      @seeds = @file_dataset.seeds
    end

    def teardown
      Memo::Database::DB[:files].delete
      Memo::Database::DB[:directories].delete
      Memo::Database::DB[:config_directories].delete
      super
    end

    describe('#seeds') do
      it('戻り値の配列の数が、対象のファイルと同じ数となること') do
        actual = @seeds.size

        file_loader = Memo::Database::FileLoader.new
        expected = file_loader.file_list_size

        _(actual).must_equal(expected)
      end
    end

    describe('#all') do
      it('取得したデータの総数が、対象のファイルと同じ数となること') do
        result = @file_dataset.all

        actual = result.size
        file_loader = Memo::Database::FileLoader.new
        expected = file_loader.file_list_size

        _(actual).must_equal(expected)
      end
    end
  end
end
