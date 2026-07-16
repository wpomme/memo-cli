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
  TEST_MEMO_DATA_SEED = [
    {
      # TODO: dirがトップにあるファイルの扱いが非常に面倒
      # README.mdは除外対象
      dir: ".",
      filename: "README.md"
    },
    {
      dir: ".",
      filename: "markdown.md"
    },
    {
      dir: ".",
      filename: "react.md"
    },
    {
      dir: "cli",
      filename: "grep.md"
    },
    {
      dir: "cli",
      filename: "find.md",
      content: TEST_FIND_FILE_CONTENT
    },
    {
      dir: "git",
      filename: "log.md"
    },
    {
      dir: "setting",
      filename: "makefile.md"
    },
    {
      dir: "shell/bash",
      filename: "test.md"
    }
  ].freeze

  def to_entry(base_dir, join_dir, filename)
    Memo::Docs::Entry.new(full_path: File.join(base_dir, join_dir, filename), dir: join_dir)
  end

  def before_setup
    super
    @tmpdir = Dir.mktmpdir
    @memo_dir = File.join(@tmpdir, "memo").freeze

    @dir_set = TEST_MEMO_DATA_SEED.to_set { |e| e[:dir] }.freeze

    @test_entries = []

    TEST_MEMO_DATA_SEED.each do |elem|
      dir_for_file = File.join(@memo_dir, elem[:dir])
      FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)
      # TEST_MEMO_DATA_SEEDのうち、memo readのテストのためにcontentのあるものはある程度の文字列を書き込む
      content = elem.key?(:content) ? elem[:content] : "# TEST #{elem[:dir]} #{elem[:filename]}\n"

      File.write(File.join(@memo_dir, elem[:dir], elem[:filename]), content)

      if elem[:filename] == "README.md"
        next
      elsif elem[:dir] == "."
        @test_entries << Memo::Docs::Entry.new(full_path: File.join(@memo_dir, elem[:filename]), dir: elem[:dir])
      else
        @test_entries << to_entry(@memo_dir, elem[:dir], elem[:filename])
      end
    end

    @test_entries.freeze

    # pp @test_entries

    # @dir_set.each do |dir|
    #   FileUtils.mkdir_p(File.join(@memo_dir, dir))
    # end

    # File.write(File.join(@memo_dir, "README.md"), "# Top README\n")
    # File.write(File.join(@memo_dir, "cli", "grep.md"), "grep command\n")
    # File.write(File.join(@memo_dir, "cli", "find.md"), TEST_FIND_FILE_CONTENT)
    # File.write(File.join(@memo_dir, "git", "log.md"), "git log\n")
    # File.write(File.join(@memo_dir, "setting", "makefile.md"), "Makefile\n")
    # File.write(File.join(@memo_dir, "shell/bash", "test.md"), "bash test command\n")

    # @test_entries = [
    #   Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "grep.md"), dir: "cli"),
    #   Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "find.md"), dir: "cli"),
    #   Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "git", "log.md"), dir: "git"),
    #   Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "setting", "makefile.md"), dir: "setting"),
    #   Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "shell", "bash", "test.md"), dir: "shell/bash")
    # ]

    @test_to_files = @test_entries
      .group_by(&:dir)
      .map do |dir, entries|
        [Rainbow(dir).green, entries.map { |entry| File.basename(entry.full_path, ".md") }]
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
