# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    def setup
      @dataset = Memo::Database::Controller::Directory.new

      @seeds = @dataset.seeds
    end

    def teardown
      Memo::Database::DB[:directories].delete
      Memo::Database::DB[:config_directories].delete
      super
    end

    describe('#seeds') do
      it('戻り値の配列の値が対象ディレクトリの数と同じになること。設定ファイルの数は含まない。') do
        actual = @seeds.size
        expected = Memo::Database::Service.rel_paths_size

        _(actual).must_equal(expected)
      end
    end
  end
end
