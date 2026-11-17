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
      it(':target_dir, :absolute_path, :parent_directory, :filename, :file_content, :tagsの七つについて、そのテストコードを作成する') do
        skip 'TODO'
      end

      it(':relative_pathについて、モックデータと値が同じであること') do
        actual = @file_loader.file_seeds.map { |seed| seed[:relative_path] }

        expected = []

        Memo::MockSeed::TEST_MOCK_DATA_SEED.each do |seed|
          @orig_target_dirs.each do |target_dir|
            next unless target_dir == seed[:target_dir]

            expected << seed[:relative_path]
          end
        end

        _(actual).must_equal(expected)
      end

      it('モックデータと実際のデータが同じであること') do
        actual = @file_loader.file_seeds

        expected = []

        Memo::MockSeed::TEST_MOCK_DATA_SEED.each do |seed|
          @target_dir_hash.each do |orig_dir, test_dir|
            is_dir_top = seed[:target_dir] == seed[:parent_directory]

            absolute_path = is_dir_top ? File.join(test_dir, "#{seed[:filename]}.md") : File.join(test_dir, seed[:relative_path], "#{seed[:filename]}.md")
            parent_directory = is_dir_top ? "#{test_dir}/" : File.join(test_dir, seed[:relative_path])

            next unless orig_dir == seed[:target_dir]

            expected << Memo::Structure::FileSeed.new(
              test_dir,
              absolute_path,
              parent_directory,
              seed[:relative_path],
              seed[:filename],
              seed[:file_content],
              seed[:tags]
            )
          end
        end

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
