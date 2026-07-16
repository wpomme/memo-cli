# frozen_string_literal: true

require_relative "../test_helper"

class TestCommand < Minitest::Test
  # TODO: #executeから#runのテストコードへ切り替えていく
  # その後、#executeをprivateにする
  TEST_FIND_FILE_CONTENT = <<~FIND_FILE
    ## find: ファイルの階層を巡回する

    - 例
    ```bash
    # 名前に"foo"を含むファイルを検索する
    find . -type f -name "*foo*"

    # 実行可能なファイルを検索して、中身の文字数などを確認する
    find . -perm -a+x -type f -exec wc {} ;
    ```

    - オプション
        - `-print0`: 改行の代わりにヌル文字を使って入力文字列を区切る
  FIND_FILE
  describe 'Command' do
    ## TODO: docsとcommandのsetupの共通化を行う

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
      File.write(File.join(@memo_dir, "cli", "find.md"), TEST_FIND_FILE_CONTENT)
      File.write(File.join(@memo_dir, "git", "log.md"), "git log\n")
      File.write(File.join(shell_dir, "bash", "test.md"), "bash test command\n")

      @test_entries = [
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "grep.md"), dir: "cli"),
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "find.md"), dir: "cli"),
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "git", "log.md"), dir: "git"),
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "shell", "bash", "test.md"), dir: "shell/bash")
      ]

      @test_memo_list = @test_entries
        .group_by(&:dir)
        .map do |dir, entries|
          filenames = entries.map { |entry| File.basename(entry.full_path, '.md') }.sort
          [Rainbow(dir).green, filenames]
        end

      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
    end

    after do
      Dir.chdir(@original_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    describe '#execute' do
      it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(['dirs'])
        end

        assert_equal "cli\ngit\nshell/bash\n", out
      end

      it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(['list'])
        end

        assert_equal @test_memo_list.flatten.join("\n") << "\n", out
      end

      it "['list', 'cli']を受け取ったときは、memo_dirの中のcliディレクトリの中にあるメモファイルを全て表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(%w[list cli])
        end

        expected = @test_entries
          .filter_map { |entry| File.basename(entry.full_path, '.md') if entry.dir == 'cli' }
          .sort
          .join("\n") << "\n"

        assert_equal expected, out
      end

      it "['read', 'find']を受け取ったときは、find.mdを全文表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(%w[read find])
        end

        assert_equal TEST_FIND_FILE_CONTENT, out
      end
    end
  end
end
