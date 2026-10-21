# frozen_string_literal: true

require_relative '../helper'

class TestService < Minitest::Test
  describe 'Service' do
    include Memo::Service

    describe '#parse_yaml_front_matter' do
      describe 'yaml形式のフロントマターが付いたマークダウン形式の文字列を読み取って、フロントマターの値を返す' do
        it '文字列、boolean、文字列型の一次元配列をパースして、ハッシュで返す' do
          title = 'RubyでYAMLを扱う'
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

          expected = { 'title' => 'RubyでYAMLを扱う', 'draft' => false, 'tags1' => ['CLI', 'Text Process', 'Built-in'],
                       'tags2' => ['TUI', 'Editor', 'File System'] }
          _(actual).must_equal(expected)
        end

        it 'Timeをパースして、ハッシュで返す' do
          time_str = '2024-02-15 10:20:30+09:00'
          markdown = <<~MARKDOWN
            ---
            # Time
            time: #{time_str}
            ---
            # 本文
            ここがマークダウンの本文です。
          MARKDOWN

          actual = parse_yaml_front_matter(markdown)

          expected = { 'time' => Time.new(time_str) }
          _(actual).must_equal(expected)
        end

        it 'front matterがなければ、空のハッシュを返す' do
          markdown = <<~MARKDOWN
            # 本文
            ここがマークダウンの本文です。
          MARKDOWN

          actual = parse_yaml_front_matter(markdown)

          expected = {}
          _(actual).must_equal(expected)
        end
      end
    end

    describe '#select_prompt' do
      it '二番目の選択肢を選んでエンターキーを押すと、その選択肢の値を返す' do
        title = '選択肢が三件あります。番号を選択してください。'

        choices = { foo: 'return 1', bar: 'return 2', baz: 'return 3' }

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
        title = '選択肢が三件あります。番号を選択してください。'

        choices = { foo: 'return 1', bar: 'return 2', baz: 'return 3' }

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
