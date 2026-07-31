# frozen_string_literal: true

require_relative "../helper"

class TestService < Minitest::Test
  describe 'Service' do
    include MemoTestLifecycleHooks
    include Memo::Service

    describe '#search' do
      describe "戻り値の型検査" do
        it '読み込んだファイルの中に該当の文字列が含まれている場合は、SearchLineの配列を返す' do
          target_file = "diff"
          ## NOTE: target_fileと同じワードで検索すれば複数行ヒットする
          search_word = target_file
          target_seed = @test_seeds.find { |seed| seed.filename == target_file }
          search_lines = search(target_seed, search_word)
          expected = search_lines.all?(Memo::Model::SearchLine)

          _(expected).must_equal(true)
        end

        it '読み込んだファイルの中に該当の文字列が含まれていない場合は、空の配列を返す' do
          target_file = "diff"
          ## target_fileと同じワードで検索すれば複数行ヒットするので都合がいい
          search_word = "hikkakaranasounakotoba"
          target_seed = @test_seeds.find { |seed| seed.filename == target_file }
          expected = search(target_seed, search_word)

          _(expected).must_equal([])
        end
      end

      describe "戻り値の値検査" do
        it '読み込んだファイルの中に該当の文字列が含まれている場合は、SearchLineの配列を返す' do
          target_file = "diff"
          search_word = target_file
          target_seed = @test_seeds.find { |seed| seed.filename == target_file }
          expected = search(target_seed, search_word)

          actual = Memo::MockSeed::TEST_DIFF_FILE_CONTENT
            .split("\n")
            .each_with_index
            .filter_map do |line, index|
              Memo::Model::SearchLine.new(path: target_seed.rel_path, line_number: index + 1, line: line) if line.include?(search_word)
            end

          _(expected).must_equal(actual)
        end
      end
    end
  end
end
