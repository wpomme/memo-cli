require_relative "../test_helper"

class TestCommandOption < Minitest::Test
  describe('#word?') do
    it '正常系' do
      words = %w[foo a A 0 9 aa aA a0 a9 0a a_ a- _a _A _0 _9 _-a _-0 _-9 _-A]
      words.each do |word|
        # テストに失敗した場合、どのwordが失敗したわからないのでexpectedをwordにする
        expected = Memo::CommandOption.word?(word) && word

        assert_equal expected, word
      end
    end

    it '正常系: 文字数' do
      word1 = "a" * 32
      word2 = "_#{'-' * 30}_"

      words = [word1, word2]

      words.each do |word|
        expected = Memo::CommandOption.word?(word) && word

        assert_equal expected, word
      end
    end

    it '異常系: 文字数' do
      word = "a" * 33

      expected = Memo::CommandOption.word?(word) || word

      assert_equal expected, word
    end

    it '異常系: 不審な文字列１' do
      words = %w[file.exe touch; / | /etc/password `whoami` $(whoami) && || & > file\ncat $IFS$()]
      words.each do |word|
        expected = Memo::CommandOption.word?(word) || word

        assert_equal expected, word
      end
    end

    it '異常系: 不審な文字列２' do
      words = %w[../../../etc/passwd ..%2F..%2F..%2Fetc%2Fpasswd ../../../etc/passwd%00.jpg symlink_to_root/../../etc/passwd]
      words.each do |word|
        expected = Memo::CommandOption.word?(word) || word

        assert_equal expected, word
      end
    end
  end

  describe '"parse_sub_command' do
    it '引数が４つ以上の場合は、:too_many_argvとnilを返す' do
      argv = %(foo bar baz qux)
      command_symbol, rest_argc = Memo::CommandOption.parse_sub_command(argv)

      assert_equal command_symbol, :too_many_argv
      assert_nil rest_argc
    end

    it '引数が0のときは、:helpと0を返す' do
      argv = []
      command_symbol, rest_argc = Memo::CommandOption.parse_sub_command(argv)

      assert_equal command_symbol, :help
      assert_equal rest_argc, 0
    end

    it '引数が1つ以上で、最初の引数がhelp, -h, --helpなら:helpと残りの引数の数を返す' do
      rest_argv = [[], ['foo'], %w[foo bar]]
      sub_commands = [['help'], ['-h'], ['--help']]

      sub_commands.each do |sub_command|
        rest_argv.each do |rest|
          argv = sub_command + rest
          command_symbol, rest_argc = Memo::CommandOption.parse_sub_command(argv)

          assert_equal command_symbol, :help
          assert_equal rest_argc, argv.length - 1
        end
      end
    end

    it '引数が1つ以上で、最初の引数がversion, -v, -V, --versionなら:versionと残りの引数の数を返す' do
      rest_argv = [[], ['foo'], %w[foo bar]]
      sub_commands = [['version'], ['-v'], ['-V'], ['--version']]

      sub_commands.each do |sub_command|
        rest_argv.each do |rest|
          argv = sub_command + rest
          command_symbol, rest_argc = Memo::CommandOption.parse_sub_command(argv)

          assert_equal command_symbol, :version
          assert_equal rest_argc, argv.length - 1
        end
      end
    end

    it '引数が1つ以上で、最初の引数がread, list, dirsなら:<sub_command_symbol>と残りの引数の数を返す' do
      rest_argv = [[], ['foo'], %w[foo bar]]
      sub_commands = [['read'], ['list'], ['dirs']]

      sub_commands.each do |sub_command|
        rest_argv.each do |rest|
          argv = sub_command + rest
          command_symbol, rest_argc = Memo::CommandOption.parse_sub_command(argv)

          assert_equal command_symbol, command_symbol.intern
          assert_equal rest_argc, argv.length - 1
        end
      end
    end
  end
end

class TestOptions < Minitest::Test
  # memo CLIの使い方が表示され、
  # その後、SystemExitを送出して終了することを確認する
  def test_print_help
    _, err = capture_io do
      exception = assert_raises(SystemExit) do
        Memo::CommandOption.to_user_message(:help)
      end

      assert_equal 0, exception.status
    end

    # assert_equal how_to_use_message, _
    assert_equal "", err
  end

  # memo CLIのバージョンが画面に表示され、
  # その後、SystemExitを送出して終了することを確認する
  def test_print_version
    out, = capture_io do
      exception = assert_raises(SystemExit) do
        Memo::CommandOption.to_user_message(:version)
      end

      assert_equal 0, exception.status
    end

    assert_equal "#{Memo::VERSION}\n", out
  end

  # 引数が多すぎる場合は、その旨のメッセージを表示し、
  # その後、SystemExitを送出して終了することを確認する
  def test_print_too_many_argv
    _, err = capture_io do
      exception = assert_raises(SystemExit) do
        Memo::CommandOption.to_user_message(:too_many_argv)
      end

      assert_equal 2, exception.status
    end

    # assert_equal how_to_use_message, _
    assert_equal "", err
  end
end
