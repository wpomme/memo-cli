# frozen_string_literal: true

require_relative '../../../helper'

class TestFileTag < Minitest::Test
  describe('Controller::FileTag') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def setup
        config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
        directory_dataset = Memo::Database::Controller::Directory.new
        file_dataset = Memo::Database::Controller::File.new
        tag_dataset = Memo::Database::Controller::Tag.new
        file_tag_dataset = Memo::Database::Controller::FileTag.new

        config_directory_dataset.seeds
        directory_dataset.seeds
        file_dataset.seeds
        tag_dataset.seeds
        @seeds = file_tag_dataset.seeds
      end

      def teardown
        Memo::Database::DB[:files_tags].delete
        Memo::Database::DB[:tags].delete
        Memo::Database::DB[:files].delete
        Memo::Database::DB[:directories].delete
        Memo::Database::DB[:config_directories].delete
        super
      end

      it('戻り値の配列の数が、重複を排除しないタグの出現回数と同じになること') do
        each_array_size = @seeds.values.map(&:size)
        actual = each_array_size.inject(:+)

        expected = Memo::Database::FileLoader.new.total_tag_size

        _(actual).must_equal(expected)
      end
    end
  end
end
