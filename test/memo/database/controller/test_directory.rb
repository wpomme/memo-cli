# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    def setup
      @config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
      @dataset = Memo::Database::Controller::Directory.new

      @config_directory_dataset.seeds
      @seeds = @dataset.seeds
    end

    def teardown
      @dataset.delete
      @config_directory_dataset.delete
      super
    end

    describe('#seeds') do
      it('戻り値の配列の値が対象ディレクトリの数と同じになること。設定ファイルの数は含まない。') do
        actual = @seeds.size
        expected = Memo::Loader::DirectoryLoader.rel_paths_size

        _(actual).must_equal(expected)
      end
    end
  end
end
