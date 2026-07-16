require "tmpdir"
require "fileutils"

require_relative "../test_helper"

class TestDocs < Minitest::Test
  # TODO: @memo_dir と @memo_dir が同階層であること
  # TODO: @entries.full_path と@entries.dir のテストコード
  # TODO: @dir_set のテストコード

  describe 'Docs' do
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

      @test_entries = [
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "grep.md"), dir: "cli"),
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "find.md"), dir: "cli"),
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "git", "log.md"), dir: "git"),
        Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "shell", "bash", "test.md"), dir: "shell/bash")
      ]

      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
    end

    after do
      Dir.chdir(@original_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    describe '#initialize' do
      describe '@entries' do
        it 'Docs#initializeは@entriesを生成し、@entriesは配列であり空ではない' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          assert_instance_of Array, entries
          refute_empty entries
        end

        it '@entriesはMemo::Docs::Entryの配列を返す' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          entries.each do |entry|
            assert_instance_of Memo::Docs::Entry, entry
          end
        end

        it '@entriesは期待するEntryの一覧と一致する' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          assert_equal @test_entries.sort_by(&:full_path), entries.sort_by(&:full_path)
        end

        it '@entries.full_pathはREADME(.md) を含まない' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)
          full_path = entries.map(&:full_path)

          refute_includes full_path, "README"
          refute_includes full_path, "README.md"
        end

        it '@entries:full_path は絶対パスである' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)
          full_paths = entries.map(&:full_path)

          full_paths.each do |full_path|
            assert File.absolute_path?(full_path)
          end
        end

        it 'Docs.new が空のmemo_dir を読み込んだ場合は、entries も空になる' do
          FileUtils.rm_rf(Dir.glob(File.join(@memo_dir, "*")))
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          assert_empty entries
        end
      end
    end

    describe '#dirs' do
      it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
        out, err = capture_io do
          Memo::Docs.dirs(@memo_dir)
        end

        assert_equal "", err
        assert_equal "cli\ngit\nshell/bash\n", out
      end
    end

    # TODO: to_filesからfilesのテストコードにする
    describe '#to_files' do
      it "memo_dirのファイルの一覧とそのファイルが属しているディレクトリを表示する" do
        expected = @test_entries
                   .group_by(&:dir)
                   .map do |dir, entries|
                     filenames = entries.map { |entry| File.basename(entry.full_path, '.md') }.sort
                     [Rainbow(dir).green, filenames]
                   end

        actual = Memo::Docs.new(@memo_dir).to_files
                           .map { |dir, filenames| [dir, filenames.sort] }

        assert_equal expected.sort, actual.sort
      end
    end

    describe '#files_by_dir' do
      it "memo_dirの中に存在するdirを受け取った場合は、そのディレクトリの中にあるメモの配列を返す" do
        exist_dir = 'cli'

        out, err = capture_io do
          Memo::Docs.files_by_dir(@memo_dir, exist_dir)
        end

        expected = @test_entries
                   .filter_map { |entry| File.basename(entry.full_path, '.md') if entry.dir == exist_dir }
                   .sort
                   .join("\n") << "\n"

        assert_equal "", err
        assert_equal expected, out
      end

      it "memo_dirの中に存在しないdirを受け取った場合は、ディレクトリが見当たらない旨のメッセージを表示する" do
        invalid_dir = 'invalid'

        out, err = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::Docs.files_by_dir(@memo_dir, invalid_dir)
          end

          assert_equal 2, exception.status
        end

        assert_equal "", err
        assert_equal "#{invalid_dir}というディレクトリはありません。\n", out
      end
    end

    describe '#list' do
      it "引数が一つの場合は#filesを呼び出す" do
        skip "TODO"
      end

      it "引数が二つの場合は#files_by_dirを呼び出す" do
        skip "TODO"
      end
    end
  end
end
