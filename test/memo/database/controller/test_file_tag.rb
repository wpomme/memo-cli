# frozen_string_literal: true

require_relative '../../../helper'

class TestFileTag < Minitest::Test
  describe('Controller::FileTag') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:files_tags].delete
        Memo::Database::DB[:tags].delete
        Memo::Database::DB[:files].delete
        Memo::Database::DB[:directories].delete
        Memo::Database::DB[:config_directories].delete
        super
      end

      it('全てのデータを挿入した場合、戻り値の配列の総数が、全てのタグの出現回数と同じになること') do
        config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
        directory_dataset = Memo::Database::Controller::Directory.new
        file_dataset = Memo::Database::Controller::File.new
        tag_dataset = Memo::Database::Controller::Tag.new
        file_tag_dataset = Memo::Database::Controller::FileTag.new

        config_directory_seeds_result = config_directory_dataset.seeds
        directory_seeds_result = directory_dataset.seeds(config_directory_seeds_result)

        file_seeds_result = file_dataset.seeds(config_directory_seeds_result, directory_seeds_result)
        tag_seeds_result = tag_dataset.seeds

        result = file_tag_dataset.seeds(file_seeds_result, tag_seeds_result)

        # resultの型をチェックする
        actual_type = result.all? do |file_tag_id, tag_ids|
          file_tag_id.instance_of?(Integer) && tag_ids.all?(Integer)
        end

        # resultの配列の総数と、全てのタグの出現回数は同じになる
        # NOTE: 計算に時間がかかっており、二行に分けて計算している
        each_array_size = result.values.map(&:size)
        actual_size = each_array_size.inject(:+)

        expected_size = Memo::Database::FileLoader.new.all_tag_count_of_appearance

        _(actual_type).must_equal(true)
        _(actual_size).must_equal(expected_size)
      end
    end
  end
end
