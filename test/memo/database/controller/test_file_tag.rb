# frozen_string_literal: true

require_relative '../../../helper'

class TestFileTag < Minitest::Test
  describe('Controller::FileTag') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def setup
        super
        @config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new(@db)
        @directory_dataset = Memo::Database::Controller::Directory.new(@db)
        @file_dataset = Memo::Database::Controller::File.new(@db)
        @tag_dataset = Memo::Database::Controller::Tag.new(@db)
        @file_tag_dataset = Memo::Database::Controller::FileTag.new(@db)

        @config_directory_dataset.seeds
        @directory_dataset.seeds
        @file_dataset.seeds
        @tag_dataset.seeds
        @seeds = @file_tag_dataset.seeds
      end

      def teardown
        @file_tag_dataset.delete
        @tag_dataset.delete
        @file_dataset.delete
        @directory_dataset.delete
        @config_directory_dataset.delete
        super
      end

      it('戻り値の配列の数が、重複を排除しないタグの出現回数と同じになること') do
        each_array_size = @seeds.values.map(&:size)
        actual = each_array_size.inject(:+)

        expected = Memo::Loader::FileLoader.new.total_tag_size

        _(actual).must_equal(expected)
      end
    end
  end
end
