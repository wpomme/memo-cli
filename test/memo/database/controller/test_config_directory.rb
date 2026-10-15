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

      it('全てのデータを挿入した場合、対象のディレクトリと同じ数の配列が戻り値となること') do
        dataset = Memo::Database::Controller::ConfigDirectory.new
        result = dataset.seeds

        actual = result.size
        expected = Memo::Config.target_dirs.size

        # resultの型をチェックする
        actual_type = result.all? do |directory_path, directory_id|
          FileTest.directory?(directory_path) && directory_id.instance_of?(Integer)
        end

        _(actual.positive?).must_equal(true)
        _(actual).must_equal(expected)
        _(actual_type).must_equal(true)
      end
    end

    describe('#all') do
      def setup
        dataset = Memo::Database::Controller::ConfigDirectory.new

        # データを挿入する
        dataset.seeds
      end

      it('挿入したデータが取得できること') do
        dataset = Memo::Database::Controller::ConfigDirectory.new

        result = dataset.all

        actual = result.all? do |row|
          row[:id].instance_of?(Integer) && row[:directory_path].instance_of?(String)
        end

        actual_size = result.size

        _(actual_size.positive?).must_equal(true)
        _(actual).must_equal(true)
      end
    end
  end
end
