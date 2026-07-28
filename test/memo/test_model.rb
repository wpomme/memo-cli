# frozen_string_literal: true

require_relative "../helper"

class TestModel < Minitest::Test
  describe 'Model' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe "GroupedFileList#to_view" do
      it "ディレクトリ名に色付けをしてディレクトリとファイル名の配列を返す" do
        expected = grouped_file_list(@test_seeds).map(&:to_view)

        actual = @test_seeds.group_by(&:dir).map do |dir, seed|
          [Rainbow(dir).green, seed.map(&:filename)]
        end

        _(expected).must_equal(actual)
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
