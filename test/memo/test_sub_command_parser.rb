# frozen_string_literal: true

require_relative "../test_helper"

class TestSubCommandParser < Minitest::Test
  include Memo::Message

  describe '"#parse!' do
    describe 'memo list' do
      it '引数がlistだけのときは、[:list]を返す' do
        expected = Memo::SubCommandParser.parse!(['list'])
        assert_equal [:list], expected
      end

      it '引数がlist <word>のときは、[:list, <word>]を返す' do
        expected = Memo::SubCommandParser.parse!(%w[list foo])
        assert_equal [:list, 'foo'], expected
      end

      it '引数がlistで、その後に続く引数が二つ以上あるときは、listの次の引数を返す' do
        expected = Memo::SubCommandParser.parse!(%w[list foo bar])
        assert_equal [:list, 'foo'], expected
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
      it '引数がhelp, -h, --helpだけのときは、ヘルプメッセージを表示する' do
        _, err = capture_io do
          exception = assert_raises(SystemExit) do
            HELP_COMMANDS.each do |h_str|
              Memo::SubCommandParser.parse!([h_str])
            end
          end

          assert_equal 0, exception.status
        end

        assert_equal "", err
      end

      it '引数がhelp, -h, --helpで、引数が一つ以上あるときでも、そのままヘルプメッセージを表示する' do
        _, err = capture_io do
          exception = assert_raises(SystemExit) do
            HELP_COMMANDS.each do |h_str|
              Memo::SubCommandParser.parse!([h_str, "foo"])
            end
          end

          assert_equal 0, exception.status
        end

        assert_equal "", err
      end

      describe('#word?') do
        it '正常系' do
          words = %w[foo a A 0 9 aa aA a0 a9 0a a_ a- _a _A _0 _9 _-a _-0 _-9 _-A]
          words.each do |word|
            # テストに失敗した場合、どのwordが失敗したわからないのでexpectedをwordにする
            expected = Memo::SubCommandParser.word?(word) && word

            assert_equal expected, word
          end
        end

        it '正常系: 文字数' do
          word1 = "a" * 32
          word2 = "_#{'-' * 30}_"

          words = [word1, word2]

          words.each do |word|
            expected = Memo::SubCommandParser.word?(word) && word

            assert_equal expected, word
          end
        end

        it '異常系: 文字数' do
          _, err = capture_io do
            exception = assert_raises(SystemExit) do
              word = "a" * 33
              Memo::SubCommandParser.word?(word)
            end

            assert_equal 2, exception.status
          end

          assert_equal "", err
        end

        it '異常系: 不審な文字列１' do
          words = %w[file.exe touch; / | /etc/password `whoami` $(whoami) && || & > file\ncat $IFS$()]
          words.each do |word|
            _, err = capture_io do
              exception = assert_raises(SystemExit) do
                Memo::SubCommandParser.word?(word)
              end

              assert_equal 2, exception.status
            end

            assert_equal "", err
          end
        end

        it '異常系: 不審な文字列２' do
          words = %w[../../../etc/passwd ..%2F..%2F..%2Fetc%2Fpasswd ../../../etc/passwd%00.jpg symlink_to_root/../../etc/passwd]
          words.each do |word|
            _, err = capture_io do
              exception = assert_raises(SystemExit) do
                Memo::SubCommandParser.word?(word)
              end

              assert_equal 2, exception.status
            end

            assert_equal "", err
          end
        end
      end
    end
  end
end
