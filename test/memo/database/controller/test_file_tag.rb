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
        file_tag_dataset.seeds
      end

      def teardown
        Memo::Database::DB[:files_tags].delete
        Memo::Database::DB[:tags].delete
        Memo::Database::DB[:files].delete
        Memo::Database::DB[:directories].delete
        Memo::Database::DB[:config_directories].delete
        super
      end

      it('全てのデータを挿入した場合、戻り値の配列の総数が、全てのタグの出現回数と同じになること') do
        file_tag_dataset = Memo::Database::Controller::FileTag.new
        result = file_tag_dataset.seeds

        each_array_size = result.values.map(&:size)
        actual = each_array_size.inject(:+)

        expected = Memo::Database::FileLoader.new.all_tag_count_of_appearance

        _(actual).must_equal(expected)
      end
    end
  end
end
