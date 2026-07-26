# frozen_string_literal: true

require_relative "../helper"

class TestModel < Minitest::Test
  describe 'Model' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe '#grouped_file_list' do
      it "Structを返す" do
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
      it '読み込んだファイルの中に該当の文字列が含まれていれば、GrepLineの配列を返す' do
        target_file = "diff"
        ## target_fileと同じワードで検索すれば複数行ヒットするので都合がいい
        search_word = target_file
        target_seed = @test_seeds.find { |seed| seed.filename == target_file }
        grep_lines = search(target_seed, search_word)

        actual = Memo::MockSeed::TEST_DIFF_FILE_CONTENT
          .split("\n")
          .each_with_index
          .filter_map do |line, index|
            Memo::Model::GrepLine.new(path: target_seed.rel_path, line_number: index, line: line) if line.include?(search_word)
          end

        _(grep_lines.first).must_be_instance_of(Memo::Model::GrepLine)
        _(grep_lines).must_be_instance_of(Array)
        _(grep_lines).must_equal(actual)
      end
    end
  end
end
