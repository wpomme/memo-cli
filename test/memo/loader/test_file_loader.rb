# frozen_string_literal: true

require_relative '../../helper'

class TestFileLoader < Minitest::Test
  describe('Memo::FileLoader') do
    include MemoLifecycleHooks

    def setup
      super
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
      @mock_file_size = Memo::MockSeed::TEST_MOCK_DATA_SEED.size
    end

    describe('#file_seeds, #file_seeds_light, #file_list_size') do
      it('要素数がモックデータと同じであること') do
        file_seeds = @file_loader.file_seeds.size
        file_seeds_light = @file_loader.file_seeds_light.size
        file_list_size = @file_loader.file_list_size

        act_size1 = [file_seeds, file_seeds_light].all?(file_list_size)

        act_size2 = file_list_size

        expected = @mock_file_size

        _(act_size1).must_equal(true)
        _(act_size2).must_equal(expected)
      end
    end

    describe('#tag_file_size, #tag_files_hash') do
      it('要素数がモックデータと同じであること') do
        target_tag_name = 'CLI'

        actual = @file_loader.tag_files_size[target_tag_name]

        expected = Memo::MockSeed::TEST_MOCK_DATA_SEED.filter do |seed|
          seed[:tags].include?(target_tag_name)
        end.size

        _(actual).must_equal(expected)
      end
    end

    describe('#total_tag_size') do
      it('要素数がモックデータと同じであること') do
        actual = @file_loader.total_tag_size

        expected = Memo::MockSeed::TEST_MOCK_DATA_SEED.inject(0) do |result, seed|
          result + seed[:tags].size
        end

        _(actual).must_equal(expected)
      end
    end

    describe('#sorted_tags') do
      it('モックデータからの加工したタグデータと同じ要素・要素数であること') do
        actual = @file_loader.sorted_tags

        expected = Memo::MockSeed::TEST_MOCK_DATA_SEED.flat_map do |seed|
          seed[:tags]
        end.uniq.sort

        _(actual).must_equal(expected)
      end
    end
  end
end
