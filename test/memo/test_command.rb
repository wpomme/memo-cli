require_relative "../test_helper"

class TestCommand < Minitest::Test
  # TODO #executeから#runのテストコードへ切り替えていく
  # その後、#executeをprivateにする
  describe 'Command' do
    before do
      @tmpdir = Dir.mktmpdir
      @memo_dir = File.join(@tmpdir, "docs")
      @memo_dir = File.join(@tmpdir, "exe")

      @test_files = %w[grep.md find.md log.mg test.md]

      FileUtils.mkdir_p(File.join(@memo_dir, "cli"))
      FileUtils.mkdir_p(File.join(@memo_dir, "git"))
      shell_dir = FileUtils.mkdir_p(File.join(@memo_dir, "shell"))
      FileUtils.mkdir_p(File.join(shell_dir, "bash"))

      File.write(File.join(@memo_dir, "README.md"), "# Top README\n")
      File.write(File.join(@memo_dir, "cli", "grep.md"), "grep command\n")
      File.write(File.join(@memo_dir, "cli", "find.md"), "find command\n")
      File.write(File.join(@memo_dir, "git", "log.md"), "git log\n")
      File.write(File.join(shell_dir, "bash", "test.md"), "bash test command\n")

      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
    end

    after do
      Dir.chdir(@original_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    describe '#execute' do
      it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
        out, err = capture_io do
          Memo::Command.new(@memo_dir).execute(['dirs'])
        end

        assert_equal "", err
        assert_equal "cli\ngit\nshell/bash\n", out
      end
    end
  end
end
