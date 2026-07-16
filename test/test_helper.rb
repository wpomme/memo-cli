# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "memo"

require "minitest/autorun"
require "minitest/spec"

module MemoTestLifecycleHooks
  include Minitest::Test::LifecycleHooks

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

  def before_setup
    # TODO: テストデータ用のフォルダ作成関数やEntryを生成する関数を作成する
    super
    @tmpdir = Dir.mktmpdir
    @memo_dir = File.join(@tmpdir, "exe")

    @dir_set = Set.new(['cli', 'git', 'setting', 'shell/bash'])
    @test_files = %w[grep.md find.md log.mg test.md]

    FileUtils.mkdir_p(File.join(@memo_dir, "cli"))
    FileUtils.mkdir_p(File.join(@memo_dir, "git"))
    FileUtils.mkdir_p(File.join(@memo_dir, "setting"))
    shell_dir = FileUtils.mkdir_p(File.join(@memo_dir, "shell"))
    FileUtils.mkdir_p(File.join(shell_dir, "bash"))

    File.write(File.join(@memo_dir, "README.md"), "# Top README\n")
    File.write(File.join(@memo_dir, "cli", "grep.md"), "grep command\n")
    File.write(File.join(@memo_dir, "cli", "find.md"), TEST_FIND_FILE_CONTENT)
    File.write(File.join(@memo_dir, "git", "log.md"), "git log\n")
    File.write(File.join(@memo_dir, "setting", "makefile.md"), "Makefile\n")
    File.write(File.join(shell_dir, "bash", "test.md"), "bash test command\n")

    @test_entries = [
      Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "grep.md"), dir: "cli"),
      Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "find.md"), dir: "cli"),
      Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "git", "log.md"), dir: "git"),
      Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "setting", "makefile.md"), dir: "setting"),
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

  def after_teardown
    super
    Dir.chdir(@original_dir)
    FileUtils.remove_entry_secure(@tmpdir)
  end
end
