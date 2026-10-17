# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::ConfigDirectory') do
    include MemoDBTestLifecycleHooks

    def setup
      @dataset = Memo::Database::Controller::ConfigDirectory.new

      @seeds = @dataset.seeds
    end

    def teardown
      @dataset.delete
      super
    end

    describe('#seeds') do
      it('戻り値の配列の数が設定ディレクトリの数と同じとなること') do
        actual = @seeds.size
        expected = Memo::Config.target_dirs.size

        _(actual).must_equal(expected)
      end
    end

    describe('#all') do
      it('取得したデータの総数が設定ディレクトリの数と同じとなること') do
        result = @dataset.all

        actual = result.size
        expected = Memo::Config.target_dirs.size

        _(actual).must_equal(expected)
      end
    end
  end
end
