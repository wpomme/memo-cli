# frozen_string_literal: true

require_relative '../../helper'

class TestFileLoader < Minitest::Test
  describe('Memo::FileLoader') do
    include MemoLifecycleHooks

    def setup
      super
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe('#file_seeds') do
      it('モックデータと実際のデータが同じであること') do
        actual = @file_loader.file_seeds

        expected = @test_file_seeds

        _(actual).must_equal(expected)
      end
    end

    describe('#tag_files_hash') do
      it('要素数がモックデータと同じであること') do
        target_tag_name = 'CLI'

        actual = @file_loader.tag_files_hash.transform_values(&:size)[target_tag_name]

        expected = Memo::MockSeed::TEST_MOCK_DATA_SEED.filter do |seed|
          seed[:tags].include?(target_tag_name)
        end.size

        _(actual).must_equal(expected)
      end
    end

    describe('#tags_sorted_by_tag_name') do
      it('モックデータからの加工したタグデータと同じ要素・要素数であること') do
        actual = @file_loader.tags_sorted_by_tag_name

        expected = Memo::MockSeed::TEST_MOCK_DATA_SEED.flat_map do |seed|
          seed[:tags]
        end.uniq.sort

        _(actual).must_equal(expected)
      end
    end
  end
end
