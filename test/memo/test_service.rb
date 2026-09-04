# frozen_string_literal: true

require_relative "../helper"

class TestService < Minitest::Test
  describe 'Service' do
    include MemoTestLifecycleHooks
    include Memo::Service

    describe '#read' do
      describe "戻り値の型検査" do
        it "文字列型の一次元配列を返す" do
          expected_seed = @test_seeds.find { |seed| seed.filename == "diff" }
          ret = read(expected_seed)

          expected = ret.all?(String)

          _(expected).must_equal(true)
        end
      end

      it "与えられたseedにしたがい、そのSeedの元となっているファイルを全文表示する。、" do
        expected_seed = @test_seeds.find { |seed| seed.filename == "diff" }
        expected = read(expected_seed)

        actual = Memo::MockSeed::TEST_DIFF_FILE_CONTENT

        _(expected).must_equal(actual.split("\n"))
      end
    end

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

    describe '#select_prompt' do
      it '二番目の選択肢を選んでエンターキーを押すと、その選択肢の値を返す' do
        title = "選択肢が三件あります。番号を選択してください。"

        choices = { foo: "return 1", bar: "return 2", baz: "return 3" }

        $stdin = StringIO.new("2\n")
        out, = capture_io do
          expected = select_prompt(title: title, choices: choices)
          _(expected).must_equal(choices[:bar])
        end

        choices_out = choices.keys.map.with_index do |key, index|
          "[#{index + 1}] #{key}"
        end

        _(out).must_equal([title].concat(choices_out).join("\n") << "\n")
      ensure
        $stdin = STDIN
      end

      it '二回無効な値を選んで、三回目で三番目の選択肢を選択してエンターキーを押すと、その選択肢の値を返す' do
        title = "選択肢が三件あります。番号を選択してください。"

        choices = { foo: "return 1", bar: "return 2", baz: "return 3" }

        $stdin = StringIO.new("5\n4\n3\n")
        out, = capture_io do
          expected = select_prompt(title: title, choices: choices)
          _(expected).must_equal(choices[:baz])
        end

        choices_out = choices.keys.map.with_index do |key, index|
          "[#{index + 1}] #{key}"
        end

        actual = ([title].concat(choices_out).join("\n") << "\n") * 3

        _(out).must_equal(actual)
      ensure
        $stdin = STDIN
      end
    end
  end
end
