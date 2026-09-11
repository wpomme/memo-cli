# frozen_string_literal: true

require_relative "../helper"

class TestSubCommandParser < Minitest::Test
  describe '"#parse!' do
    describe 'memo list(-l, --list)' do
      it '引数がlistのときは、[:list]を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command])
          _([:list]).must_equal(expected)
        end
      end

      it '引数がlist <word>のときは、[:list, <word>]を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo"])
          _([:list, 'foo']).must_equal(expected)
        end
      end

      it '引数がlistで、その後に続く引数が二つ以上あるときは、listの次の引数を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo", "bar"])
          _([:list, 'foo']).must_equal(expected)
        end
      end
    end

    describe 'memo read(-r, --read)' do
      it '引数がreadだけのときは、エラーメッセージを表示して異常終了する' do
        _, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::READ_COMMAND_SPEC.take_command_forms.each do |command|
              expected = Memo::SubCommandParser.parse!([command])
              _([:read]).must_equal(expected)
            end
          end

          _(exception.status).must_equal(2)
        end

        _("").must_equal(err)
      end

      it '引数がread <word>のときは、[:read, <word>]' do
        Memo::SubCommandParser::READ_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo"])
          _([:read, "foo"]).must_equal(expected)
        end
      end

      it '引数がreadで、その後に続く引数が二つ以上あるときは、readの次の引数を返す' do
        Memo::SubCommandParser::READ_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo", "bar"])
          _([:read, "foo"]).must_equal(expected)
        end
      end

      it '引数が一つだけなら、readの引数とする' do
        expected = Memo::SubCommandParser.parse!(%w[foo])
        _([:read, "foo"]).must_equal(expected)
      end
    end

    describe 'memo search(-s, --search)' do
      it '引数がsearchだけのときは、エラーメッセージを表示して異常終了する' do
        _, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::SEARCH_COMMAND_SPEC.take_command_forms.each do |command|
              expected = Memo::SubCommandParser.parse!([command])
              _([:search]).must_equal(expected)
            end
          end

          _(exception.status).must_equal(2)
        end

        _("").must_equal(err)
      end

      it '引数がsearch <word>のときは、[:search, <word>]' do
        Memo::SubCommandParser::SEARCH_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo"])
          _([:search, "foo"]).must_equal(expected)
        end
      end

      it '引数がsearchで、その後に続く引数が二つ以上あるときは、searchの次の引数を返す' do
        Memo::SubCommandParser::SEARCH_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo", "bar"])
          _([:search, "foo"]).must_equal(expected)
        end
      end
    end

    describe 'memo dirs(-d, --dirs)' do
      it '引数がdirsだけのときは、:dirsを返す' do
        Memo::SubCommandParser::DIRS_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command])
          _([:dirs]).must_equal(expected)
        end
      end

      it '引数がdirsで、その後に続く引数があってもそのまま:dirsを返す' do
        Memo::SubCommandParser::DIRS_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo"])
          _([:dirs]).must_equal(expected)
        end
      end
    end

    describe 'memo help(-h, --help)' do
      parser = Memo::SubCommandParser.parser
      help_message_expected = parser.on.to_a.each.with_index.reduce("") do |result, (line, index)|
        result += line
        # opts.bannerとopts.separatorの間には手動で改行を入れる必要がある
        result += "\n" if index.zero?
        result
      end
        .chomp

      it '引数がhelpだけのときは、ヘルプメッセージを表示する' do
        out, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::HELP_COMMAND_SPEC.take_command_forms.each do |sub_command|
              Memo::SubCommandParser.parse!([sub_command])
            end
          end

          _(exception.status).must_equal(0)
        end

        _("").must_equal(err)
        _(help_message_expected).must_equal(out)
      end

      it '引数がhelpで、引数が一つ以上あるときでも、そのままヘルプメッセージを表示する' do
        out, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser::HELP_COMMAND_SPEC.take_command_forms.each do |sub_command|
              Memo::SubCommandParser.parse!([sub_command, "foo"])
            end
          end

          _(exception.status).must_equal(0)
        end

        _("").must_equal(err)
        _(help_message_expected).must_equal(out)
      end

      it '引数がない場合は、ヘルプメッセージを表示する' do
        out, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser.parse!([])
          end

          _(exception.status).must_equal(0)
        end

        _("").must_equal(err)
        _(help_message_expected).must_equal(out)
      end
    end
  end
end
