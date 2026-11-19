# frozen_string_literal: true

require_relative '../../helper'

class TestFileLoader < Minitest::Test
  describe('Memo::FileLoader') do
    include MemoLifecycleHooks

    def setup
      super
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
      @mock_seeds = Memo::MockSeed::TEST_MOCK_DATA_SEED
    end

    describe('#file_seeds: FileSeedの各項目について値のテストを行う') do
      it(':target_dirについて、テストデータの対象ディレクトリと同じ値になること') do
        actual = @file_loader.file_seeds.map { |seed| seed[:target_dir] }
          .uniq

        expected = @test_target_dirs

        _(actual).must_equal(expected)
      end

      it(':absolute_pathについて、モックデータと実際のデータが同じであること') do
        skip 'TODO'
        actual = @file_loader.file_seeds.map { |seed| seed[:absolute_path] }

        expected = @mock_seeds.flat_map do |seed|
          @target_dir_hash.filter_map do |orig_dir, test_dir|
            is_dir_top = seed[:target_dir] == seed[:parent_directory]

            absolute_path = is_dir_top ? File.join(test_dir, "#{seed[:filename]}.md") : File.join(test_dir, seed[:relative_path], "#{seed[:filename]}.md")

            absolute_path if orig_dir == seed[:target_dir]
          end
        end

        _(actual.to_set - expected.to_set).must_equal(Set.new)
      end

      it(':relative_pathについて、重複を排除したものがモックデータと同じ値になること') do
        actual = @file_loader.file_seeds.map { |seed| seed[:relative_path] }

        expected = @mock_seeds.map { |seed| seed[:relative_path] }

        _(actual.to_set - expected.to_set).must_equal(Set.new)
      end

      it(':parent_directoryについて、モックデータと実際のデータが同じであること') do
        actual = @file_loader.file_seeds.map { |seed| seed[:parent_directory] }

        expected = @mock_seeds.flat_map do |seed|
          @target_dir_hash.filter_map do |orig_dir, test_dir|
            is_dir_top = seed[:target_dir] == seed[:parent_directory]

            parent_directory = is_dir_top ? "#{test_dir}/" : File.join(test_dir, seed[:relative_path])

            parent_directory if orig_dir == seed[:target_dir]
          end
        end

        _(actual.to_set - expected.to_set).must_equal(Set.new)
      end

      it(':filenameについて、モックデータと実際のデータが同じであること') do
        skip 'TODO'
        actual = @file_loader.file_seeds.map { |seed| seed[:filename] }

        expected = @mock_seeds.map { |seed| seed[:filename] }

        _(actual.to_set - expected.to_set).must_equal(Set.new)
      end

      it(':file_contentについて、モックデータと実際のデータが同じであること') do
        skip 'TODO'
        act_set = @file_loader.file_seeds.map { |seed| seed[:file_content] }

        exp_set = @mock_seeds.map { |seed| seed[:file_content] }

        actual = act_set - exp_set

        _(actual.empty?).must_equal(true)
      end

      it(':tagsについて、モックデータと実際のデータが同じであること') do
        skip 'TODO'
        actual = @file_loader.file_seeds.map { |seed| seed[:tags] }

        expected = @mock_seeds.map { |seed| seed[:tags] }

        _(actual.to_set - expected.to_set).must_equal(Set.new)
      end
    end

    describe('#public_methods') do
      it('tags_sorted_by_file_size, tags_sorted_by_tag_name, tag_files_hashをグループ化してテストコードを作成する') do
        skip 'TODO'
      end

      describe('#tag_files_hash') do
        it('要素数がモックデータと同じであること') do
          skip 'TODO'
          target_tag_name = 'CLI'

          actual = @file_loader.tag_files_hash.transform_values(&:size)[target_tag_name]

          expected = @mock_seeds.filter do |seed|
            seed[:tags].include?(target_tag_name)
          end.size

          _(actual).must_equal(expected)
        end
      end

      describe('#tags_sorted_by_tag_name') do
        it('モックデータからの加工したタグデータと同じ要素・要素数であること') do
          actual = @file_loader.tags_sorted_by_tag_name

          expected = @mock_seeds.flat_map { |seed| seed[:tags] }
            .uniq.sort

          _(actual).must_equal(expected)
        end
      end

      it('duplicated_seeds, seeds_by_parent_directory, seeds_grouped_by_directory, empty_tags_seeds_grouped_by_directoryをグループ化してテストコードを作成する') do
        skip 'TODO'
      end

      describe('#duplicated_seeds') do
        it('ファイル名で集計すると、実際にファイル名が二つ以上あること。また、重複したファイル名が存在しなければ、空の配列を返すこと') do
          ret = @file_loader.duplicated_seeds

          # NOTE: 分岐を消したい
          if ret.empty?
            _(ret).must_equal([])
          else
            tallied = ret.map { |file_seed| file_seed[:filename] }.tally

            actual = tallied.values.all? { |e| e > 1 }

            _(actual).must_equal(true)
          end
        end
      end

      it('absolute_filename_to_tagsのテストコードも作成する') do
        skip 'TODO'
      end
    end
  end
end
