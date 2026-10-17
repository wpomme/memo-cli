# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::ConfigDirectory') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:config_directories].delete
        super
      end

      it('全てのデータを挿入した場合、その配列の値が設定ディレクトリの数と同じになること') do
        dataset = Memo::Database::Controller::ConfigDirectory.new
        result = dataset.seeds

        actual = result.size
        expected = Memo::Config.target_dirs.size

        _(actual).must_equal(expected)
      end
    end

    describe('#all') do
      def setup
        dataset = Memo::Database::Controller::ConfigDirectory.new

        # データを挿入する
        dataset.seeds
      end

      it('挿入したデータが取得でき、その総数が設定ディレクトリの数と同じであること') do
        dataset = Memo::Database::Controller::ConfigDirectory.new

        result = dataset.all

        actual = result.size
        expected = Memo::Config.target_dirs.size

        _(actual).must_equal(expected)
      end
    end
  end
end
