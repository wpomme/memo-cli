# frozen_string_literal: true

require_relative "../helper"

class TestService < Minitest::Test
  describe 'Service' do
    include MemoTestLifecycleHooks
    include Memo::Service

    describe '#read' do
      describe "戻り値の型検査" do
        it "文字列型の一次元配列を返す" do
          target_file = @fixed_mock_file
          expected_seed = @test_seeds.find { |seed| seed.basename == target_file }
          ret = read(expected_seed)

          expected = ret.all?(String)

          _(true).must_equal(expected)
        end
      end

      it "与えられたseedにしたがい、そのSeedの元となっているファイルを全文表示する。、" do
        target_file = @fixed_mock_file
        expected_seed = @test_seeds.find { |seed| seed.basename == target_file }
        expected = read(expected_seed)

        actual = Memo::MockSeed::TEST_LS_FILE_CONTENT

        _(actual.split("\n")).must_equal(expected)
      end
    end

    describe '#search' do
      describe "戻り値の型検査" do
        it '読み込んだファイルの中に該当の文字列が含まれている場合は、SearchLineの配列を返す' do
          target_file = @fixed_mock_file
          ## NOTE: target_fileと同じワードで検索すれば複数行ヒットする
          search_word = target_file
          target_seed = @test_seeds.find { |seed| seed.basename == target_file }
          search_lines = search(target_seed, search_word)
          expected = search_lines.all?(Memo::Model::SearchLine)

          _(true).must_equal(expected)
        end

        it '読み込んだファイルの中に該当の文字列が含まれていない場合は、空の配列を返す' do
          target_file = @fixed_mock_file
          ## target_fileと同じワードで検索すれば複数行ヒットするので都合がいい
          search_word = "hikkakaranasounakotoba"
          target_seed = @test_seeds.find { |seed| seed.basename == target_file }
          expected = search(target_seed, search_word)

          _([]).must_equal(expected)
        end
      end

      describe "戻り値の値検査" do
        it '読み込んだファイルの中に該当の文字列が含まれている場合は、SearchLineの配列を返す' do
          target_file = @fixed_mock_file
          search_word = target_file
          target_seed = @test_seeds.find { |seed| seed.basename == target_file }
          expected = search(target_seed, search_word)

          actual = Memo::MockSeed::TEST_LS_FILE_CONTENT
            .split("\n")
            .each_with_index
            .filter_map do |line, index|
              Memo::Model::SearchLine.new(path: target_seed.rel_path, line_number: index + 1, line: line) if line.include?(search_word)
            end

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#parse_yaml_front_matter' do
      describe 'yaml形式のフロントマターが付いたマークダウン形式の文字列を読み取って、フロントマターの値を返す' do
        it '文字列、boolean、文字列型の一次元配列をパースして、ハッシュで返す' do
          title = "RubyでYAMLを扱う"
          markdown = <<~MARKDOWN
            ---
            # title: 文字列
            title: #{title}
            # draft: boolean
            draft: false
            # tags1: Array<String>
            tags1: ["CLI", "Text Process", "Built-in"]
            # tags2: Array<String>
            tags2:
              - TUI
              - Editor
              - File System
            ---
            # 本文
            ここがマークダウンの本文です。
          MARKDOWN

          actual = parse_yaml_front_matter(markdown)

          expected = { "title" => "RubyでYAMLを扱う", "draft" => false, "tags1" => ["CLI", "Text Process", "Built-in"],
                       "tags2" => ["TUI", "Editor", "File System"] }
          _(actual).must_equal(expected)
        end

        it 'Timeをパースして、ハッシュで返す' do
          time_str = "2024-02-15 10:20:30+09:00"
          markdown = <<~MARKDOWN
            ---
            # Time
            time: #{time_str}
            ---
            # 本文
            ここがマークダウンの本文です。
          MARKDOWN

          actual = parse_yaml_front_matter(markdown)

          expected = { "time" => Time.new(time_str) }
          _(actual).must_equal(expected)
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
          _(choices[:bar]).must_equal(expected)
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
          _(choices[:baz]).must_equal(expected)
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
