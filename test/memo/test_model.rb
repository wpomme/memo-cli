# frozen_string_literal: true

require_relative "../helper"

class TestModel < Minitest::Test
  describe 'Model' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe "GroupedFileList#to_view" do
      describe "引数を取らず、mapで#to_viewを使用する場合" do
        it "戻り値は二次元配列である" do
          expected = grouped_file_list(@test_seeds).map(&:to_view)

          _(expected).must_be_instance_of(Array)

          expected.each do |exp|
            _(exp).must_be_instance_of(Array)
          end
        end

        it "ディレクトリ名に色付けをしてディレクトリとファイル名の配列を返す" do
          expected = grouped_file_list(@test_seeds).map(&:to_view)

          actual = @test_seeds.group_by(&:dir).map do |dir, grouped|
            [Rainbow(dir).green] + grouped.map(&:filename)
          end

          _(expected).must_equal(actual)
        end
      end

      describe "引数にディレクトリ名を取り、filter_mapで#to_viewを使用する場合" do
        it "引数と同じディレクトリ名を色付けして、その中のファイル名と一緒に値を返す" do
          target_dir = "cli"
          expected = grouped_file_list(@test_seeds).filter_map { |grouped| grouped.to_view(target_dir) }

          actual = @test_seeds.group_by(&:dir).filter_map do |dir, grouped|
            [Rainbow(dir).green] + grouped.map(&:filename) if dir == target_dir
          end

          _(expected).must_equal(actual)
        end

        it "メモの中に存在しないディレクトリ名を受け取った場合は、空の配列を返す" do
          target_dir = "not_exist_dir"
          expected = grouped_file_list(@test_seeds).filter_map { |grouped| grouped.to_view(target_dir) }

          _(expected).must_equal([])
        end
      end
    end

    describe '#grouped_file_list' do
      it "Seedの配列を受け取ったら、GroupedFileListを返す" do
        expected = grouped_file_list(@test_seeds)

        actual = @test_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename)
          )
        end

        _(actual).must_equal(expected)
      end
    end

    describe '#search' do
      it '読み込んだファイルの中に該当の文字列が含まれていれば、SearchLineの配列を返す' do
        target_file = "diff"
        ## target_fileと同じワードで検索すれば複数行ヒットするので都合がいい
        search_word = target_file
        target_seed = @test_seeds.find { |seed| seed.filename == target_file }
        search_lines = search(target_seed, search_word)

        actual = Memo::MockSeed::TEST_DIFF_FILE_CONTENT
          .split("\n")
          .each_with_index
          .filter_map do |line, index|
            Memo::Model::SearchLine.new(path: target_seed.rel_path, line_number: index + 1, line: line) if line.include?(search_word)
          end

        _(search_lines.first).must_be_instance_of(Memo::Model::SearchLine)
        _(search_lines).must_be_instance_of(Array)
        _(search_lines).must_equal(actual)
      end

      it '読み込んだファイルの中に該当の文字列が含まれていなければ、nilを返す' do
        target_file = "diff"
        ## target_fileと同じワードで検索すれば複数行ヒットするので都合がいい
        search_word = "hikkakaranasounakotoba"
        target_seed = @test_seeds.find { |seed| seed.filename == target_file }
        expected = search(target_seed, search_word)

        assert_nil expected
      end
    end
  end
end
