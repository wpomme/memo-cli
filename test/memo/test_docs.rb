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
          def test_load_entries_returns_entry_structs
            docs = Memo::Docs.new(@memo_dir)
            entries = docs.instance_variable_get(:@entries)

            entries.each do |entry|
              assert_instance_of Memo::Docs::Entry, entry
            end
          end
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
  end
end
