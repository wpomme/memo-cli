# frozen_string_literal: true

require_relative '../helper'

class TestSubCommandParser < Minitest::Test
  describe '"#parse!' do
    describe 'memo list(-l, --list)' do
      it '引数がlistのときは、[:list]を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command])

          expected = { list: nil }

          _(actual).must_equal(expected)
        end
      end

      it '引数がlist <word>のときは、[:list, <word>]を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo'])

          expected = { list: 'foo' }

          _(actual).must_equal(expected)
        end
      end

      it '引数がlistで、その後に続く引数が二つ以上あるときは、listの次の引数を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo', 'bar'])

          expected = { list: 'foo' }

          _(actual).must_equal(expected)
        end
      end
    end

    describe 'memo read(-r, --read)' do
      it '引数がreadだけのときは、エラーメッセージを表示して異常終了する' do
        capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::READ_COMMAND_SPEC.take_command_forms.each do |command|
              actual = Memo::SubCommandParser.parse!([command])
              _(actual).must_equal([:read])
            end
          end

          _(exception.status).must_equal(2)
        end
      end

      it '引数がread <word>のときは、[:read, <word>]' do
        Memo::SubCommandParser::READ_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo'])

          expected = { read: 'foo' }

          _(actual).must_equal(expected)
        end
      end

      it '引数がreadで、その後に続く引数が二つ以上あるときは、readの次の引数を返す' do
        Memo::SubCommandParser::READ_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo', 'bar'])

          expected = { read: 'foo' }

          _(actual).must_equal(expected)
        end
      end

      it '引数が一つだけなら、readの引数とする' do
        actual = Memo::SubCommandParser.parse!(%w[foo])

        expected = { read: 'foo' }

        _(actual).must_equal(expected)
      end
    end

    describe 'memo search(-s, --search)' do
      it '引数がsearchだけのときは、エラーメッセージを表示して異常終了する' do
        capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::SEARCH_COMMAND_SPEC.take_command_forms.each do |command|
              actual = Memo::SubCommandParser.parse!([command])

              expected = { search: nil }

              _(actual).must_equal(expected)
            end
          end

          _(exception.status).must_equal(2)
        end
      end

      it '引数がsearch <word>のときは、[:search, <word>]' do
        Memo::SubCommandParser::SEARCH_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo'])

          expected = { search: 'foo' }

          _(actual).must_equal(expected)
        end
      end

      it '引数がsearchで、その後に続く引数が二つ以上あるときは、searchの次の引数を返す' do
        Memo::SubCommandParser::SEARCH_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo', 'bar'])

          expected = { search: 'foo' }

          _(actual).must_equal(expected)
        end
      end
    end

    describe 'memo dirs(-d, --dirs)' do
      it '引数がdirsだけのときは、:dirsを返す' do
        Memo::SubCommandParser::DIRS_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command])

          expected = { dirs: true }

          _(actual).must_equal(expected)
        end
      end

      it '引数がdirsで、その後に続く引数があってもそのまま:dirsを返す' do
        Memo::SubCommandParser::DIRS_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo'])

          expected = { dirs: true }

          _(actual).must_equal(expected)
        end
      end
    end

    describe 'memo tag(-x, --tag)' do
      it '引数がtagsだけのときは、エラーメッセージを返す' do
        # TODO
        capture_io do
          exception = assert_raises(SystemExit) do
            Memo::Command.new(@test_repo).execute(['tag'])
          end

          _(exception.status).must_equal(2)
        end
      end

      it '引数がtag WORDのときは、[:tag, <word>]を返す' do
        word = 'foo'

        Memo::SubCommandParser::TAG_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, word])

          expected = { tag: word }

          _(actual).must_equal(expected)
        end
      end
    end

    describe 'memo tags(-t, --tags)' do
      it '引数がtagsだけのときは、:tagsを返す' do
        Memo::SubCommandParser::TAGS_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command])

          expected = { tags: nil }

          _(actual).must_equal(expected)
        end
      end

      it '引数がtagsで、その次に続く引数がTAGS_SUB_COMMANDSの値のどれかなら、それに対応するシンボルと一緒に値を返す' do
        Memo::SubCommandParser::TAGS_COMMAND_SPEC.take_command_forms.each do |command|
          Memo::SubCommandParser::TAGS_SUB_COMMANDS.values.flatten.each do |sub_command|
            actual = Memo::SubCommandParser.parse!([command, sub_command])

            found = Memo::SubCommandParser::TAGS_SUB_COMMAND_FIND.call(Memo::SubCommandParser::TAGS_SUB_COMMANDS, sub_command)

            expected = { tags: found }

            _(actual).must_equal(expected)
          end
        end
      end

      it '引数がtagsで、その後に続く引数があってもそのまま:tagsを返す' do
        Memo::SubCommandParser::TAGS_COMMAND_SPEC.take_command_forms.each do |command|
          actual = Memo::SubCommandParser.parse!([command, 'foo'])

          expected = { tags: nil }

          _(actual).must_equal(expected)
        end
      end
    end

    describe 'memo help(-h, --help)' do
      parser = Memo::SubCommandParser.parser
      help_message_expected = parser.on.to_a.each.with_index.reduce('') do |result, (line, index)|
        result += line
        # opts.bannerとopts.separatorの間には手動で改行を入れる必要がある
        result += "\n" if index.zero?
        result
      end
        .chomp

      it '引数がhelpだけのときは、ヘルプメッセージを表示する' do
        actual, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::HELP_COMMAND_SPEC.take_command_forms.each do |sub_command|
              Memo::SubCommandParser.parse!([sub_command])
            end
          end

          _(exception.status).must_equal(0)
        end

        _(actual).must_equal(help_message_expected)
      end

      it '引数がhelpで、引数が一つ以上あるときでも、そのままヘルプメッセージを表示する' do
        actual, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::HELP_COMMAND_SPEC.take_command_forms.each do |sub_command|
              Memo::SubCommandParser.parse!([sub_command, 'foo'])
            end
          end

          _(exception.status).must_equal(0)
        end

        _(actual).must_equal(help_message_expected)
      end

      it '引数がない場合は、ヘルプメッセージを表示する' do
        actual, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser.parse!([])
          end

          _(exception.status).must_equal(0)
        end

        _(actual).must_equal(help_message_expected)
      end
    end
  end
end
