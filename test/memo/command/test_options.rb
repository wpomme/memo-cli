require_relative "../../test_helper"

class TestOptions < Minitest::Test
  # #parse_auxのテスト
  # 引数が三つ以上の場合は:too_many_argsを返す
  def test_too_many_args
    argv = %(foo bar baz)
    expected = Memo::MemoOptionParser.parse_aux(argv)
    assert_equal expected, :too_many_args
  end

  # 引数が0のときは:how_to_useを返す
  def test_empty_args
    argv = []
    expected = Memo::MemoOptionParser.parse_aux(argv)
    assert_equal expected, :how_to_use
  end

  # 引数が1のときで、"help", "-h", "--help"なら:how_to_useを返す
  def test_help_success
    argv_arr = [['help'], ['-h'], ['--help']]
    argv_arr.each do |argv|
      expected = Memo::MemoOptionParser.parse_aux(argv)
      assert_equal :how_to_use, expected
    end
  end

  # 引数が1のときで、"version", "-v", "-V", "--version"なら:versionを返す
  def test_version_success
    argv_arr = [['version'], ['-v'], ['-V'], ['--version']]
    argv_arr.each do |argv|
      expected = Memo::MemoOptionParser.parse_aux(argv)
      assert_equal :version, expected
    end
  end

  # memo CLIの使い方が表示され、
  # その後、SystemExitを送出して終了することを確認する
  def test_print_help
    _, err = capture_io do
      exception = assert_raises(SystemExit) do
        Memo::MemoOptionParser.to_user_message(:how_to_use)
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
        Memo::MemoOptionParser.to_user_message(:version)
      end

      assert_equal 0, exception.status
    end

    assert_equal "#{Memo::VERSION}\n", out
  end

  # 引数が多すぎる場合は、その旨のメッセージを表示し、
  # その後、SystemExitを送出して終了することを確認する
  def test_print_too_many_args
    _, err = capture_io do
      exception = assert_raises(SystemExit) do
        Memo::MemoOptionParser.to_user_message(:too_many_args)
      end

      assert_equal 2, exception.status
    end

    # assert_equal how_to_use_message, _
    assert_equal "", err
  end
end
# ありうる引数のパターンを作成して、それぞれについてテストを作成する
# 引数よりコマンドのごとに考えたほうが良さそう
#
# 全体
# 引数が1 -> 引数によって各コマンドへ分岐し、<word>ならmemo read、それ以外の文字列ならエラー
# 引数が2 -> 最初の引数で各コマンドへ分岐し、登録されていない文字列ならそこでエラーを出す
#            二番目の引数は、各コマンドごとの指定に従う
# <word> -> 先頭と最後はa-zA-Z、文中はそれにハイフンを追加した文字列のみ受け付ける。32文字以上はエラーにする。
# <dirs> -> word と同じ条件にしたい。memo直下にmemoがあると面倒なので、それ以外のものはetcとかmiscに入れよう
#
# memo help
# 正常系
# OK
#
# 異常系
# memo -h <args>
# memo help <args>
# memo --help <args>
# -> 余分な引数がついているというエラーを出す
#
# memo version
# OK
#
# 異常系
# memo -v <args>
# memo -V <args>
# memo --version <args>
# memo version <args>
# -> memo versionと同じにする
#
# memo dirs
# 正常系
# memo dirs
# 異常系
# memo dirs <args>
#
# memo list
# 正常系
# memo list
# memo list <dir>
# dir によって正常か異常かが変化する
# 異常系
# memo list <arg2>
# arg2は二つ以上の引数の場合
#
# memo read
# 正常系
# memo <word>
# memo read <word>
# word によって正常か異常かが変化する
# 異常系
# memo <arg2>
# memo read <arg2>
# -> memo <arg2>ほ判定が厄介そう
