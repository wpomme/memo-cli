require "tmpdir"
require "fileutils"

require_relative "../test_helper"

class TestDocs < Minitest::Test
  # TODO: @memo_dir と @memo_dir が同階層であること
  # TODO: @entries.full_path と@entries.dir のテストコード
  # TODO: @dir_set のテストコード

  def setup
    @tmpdir = Dir.mktmpdir
    @memo_dir = File.join(@tmpdir, "docs")
    @memo_dir = File.join(@tmpdir, "exe")

    @test_files = %w[grep.md find.md log.mg]

    FileUtils.mkdir_p(File.join(@memo_dir, "cli"))
    FileUtils.mkdir_p(File.join(@memo_dir, "git"))

    File.write(File.join(@memo_dir, "README.md"), "# Top README\n")
    File.write(File.join(@memo_dir, "cli", "grep.md"), "grep command\n")
    File.write(File.join(@memo_dir, "cli", "find.md"), "find command\n")
    File.write(File.join(@memo_dir, "git", "log.md"), "git log\n")

    @original_dir = Dir.pwd
    Dir.chdir(@tmpdir)
  end

  def teardown
    Dir.chdir(@original_dir)
    FileUtils.remove_entry(@tmpdir)
  end

  # Docs#initialize が entries を生成する
  def test_initialize_loads_entries
    docs = Memo::Docs.new(@memo_dir)
    entries = docs.instance_variable_get(:@entries)

    assert_instance_of Array, entries
    refute_empty entries
  end

  # Docs#initialize で生成されたentries はMemo::Docs::Entry の配列を返す
  def test_load_entries_returns_entry_structs
    docs = Memo::Docs.new(@memo_dir)
    entries = docs.instance_variable_get(:@entries)

    entries.each do |entry|
      assert_instance_of Memo::Docs::Entry, entry
    end
  end

  # Docs#load_entries で生成されたentries#full_path はREADME(.md) を含まない
  def test_load_entries_excludes_readme
    docs = Memo::Docs.new(@memo_dir)
    entries = docs.instance_variable_get(:@entries)
    full_path = entries.map(&:full_path)

    refute_includes full_path, "README"
    refute_includes full_path, "README.md"
  end

  # Docs#load_entries:full_path は絶対パスである
  def test_load_entries_sets_full_path
    docs = Memo::Docs.new(@memo_dir)
    entries = docs.instance_variable_get(:@entries)
    full_paths = entries.map(&:full_path)

    full_paths.each do |full_path|
      assert File.absolute_path?(full_path)
    end
  end

  # Docs.new が空のmemo_dir を読み込んだ場合は、entries も空になる
  def test_load_entries_with_empty_memo_directory
    FileUtils.rm_rf(Dir.glob(File.join(@memo_dir, "*")))
    docs = Memo::Docs.new(@memo_dir)
    entries = docs.instance_variable_get(:@entries)

    assert_empty entries
  end
end
