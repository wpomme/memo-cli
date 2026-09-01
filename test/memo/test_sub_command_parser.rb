# frozen_string_literal: true

require_relative "../helper"

class TestSubCommandParser < Minitest::Test
  describe '"#parse!' do
    # TODO: read, searchなど、-r, -sでもコマンドが実行できるようになったので、そのようにテストを修正する
    describe 'memo list' do
      it '引数がlist, -l, --listだけのときは、[:list]を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command])
          _(expected).must_equal([:list])
        end
      end

      it '引数がlist, -l, --list <word>のときは、[:list, <word>]を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo"])
          _(expected).must_equal([:list, 'foo'])
        end
      end

      it '引数がlist, -l, --listで、その後に続く引数が二つ以上あるときは、listの次の引数を返す' do
        Memo::SubCommandParser::LIST_COMMAND_SPEC.take_command_forms.each do |command|
          expected = Memo::SubCommandParser.parse!([command, "foo", "bar"])
          _(expected).must_equal([:list, 'foo'])
        end
      end
    end

    describe 'memo read' do
      it '引数がreadだけのときは、エラーメッセージを表示して異常終了する' do
        _, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser.parse!(['read'])
          end

          assert_equal 2, exception.status
        end

        assert_equal "", err
      end

      it '引数がread <word>のときは、[:read, <word>]' do
        expected = Memo::SubCommandParser.parse!(%w[read foo])
        assert_equal [:read, 'foo'], expected
      end

      it '引数がreadで、その後に続く引数が二つ以上あるときは、readの次の引数を返す' do
        expected = Memo::SubCommandParser.parse!(%w[read foo bar])
        assert_equal [:read, 'foo'], expected
      end

      it '引数が一つだけで、サブコマンドではなく、不正な文字列でなければ、readの引数とする' do
        expected = Memo::SubCommandParser.parse!(%w[foo])
        assert_equal [:read, 'foo'], expected
      end
    end

    describe 'memo search' do
      it '引数がsearchだけのときは、エラーメッセージを表示して異常終了する' do
        _, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::SubCommandParser.parse!(['search'])
          end

          assert_equal 2, exception.status
        end

        assert_equal "", err
      end

      it '引数がsearch <word>のときは、[:search, <word>]' do
        expected = Memo::SubCommandParser.parse!(%w[search foo])
        assert_equal [:search, 'foo'], expected
      end

      it '引数がsearchで、その後に続く引数が二つ以上あるときは、searchの次の引数を返す' do
        expected = Memo::SubCommandParser.parse!(%w[search foo bar])
        assert_equal [:search, 'foo'], expected
      end
    end

    describe 'memo dirs' do
      it '引数がdirsだけのときは、:dirsを返す' do
        expected = Memo::SubCommandParser.parse!(['dirs'])
        assert_equal [:dirs], expected
      end

      it '引数がdirsで、その後に続く引数があってもそのまま:dirsを返す' do
        expected = Memo::SubCommandParser.parse!(%w[dirs foo])
        assert_equal [:dirs], expected
      end
    end

    describe 'memo help' do
      help_message_expected = <<~MESSAGE
        Usage: memo subcommand [arguments]

        Subcommand List:
            -r, --read WORD                  対象のメモを全文表示する
            -l, --list [DIRS]                メモの一覧を表示する
            -d, --dirs                       メモの中のディレクトリの一覧を表示する
            -s, --search WORD                検索した文字列で全てのメモを全文検索する
            -h, --help                       memoコマンドのヘルプ
      MESSAGE

      it '引数がhelp, -h, --helpだけのときは、ヘルプメッセージを表示する' do
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

      it '引数がhelp, -h, --helpで、引数が一つ以上あるときでも、そのままヘルプメッセージを表示する' do
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
