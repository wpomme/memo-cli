# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "memo"

require "minitest/autorun"
require "minitest/spec"
require "minitest/expectations"

require "tmpdir"
require "fileutils"

module MemoTestLifecycleHooks
  include Minitest::Test::LifecycleHooks
  include Memo::MemoFileUtility

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

  ## そのうち廃止する
  def to_entry(base_dir, join_dir, filename)
    full_path = join_dir == "memo" ? File.join(base_dir, filename) : File.join(base_dir, join_dir, filename)
    Memo::Docs::Entry.new(full_path: full_path, filename: File.basename(full_path, '.md'), dir: join_dir)
  end

  def to_repository_entry(base_dir, join_dir, filename)
    full_path = join_dir == "memo" ? File.join(base_dir, filename) : File.join(base_dir, join_dir, filename)
    Memo::Repository::Entry.new(full_path: full_path, filename: File.basename(full_path, '.md'), dir: join_dir)
  end

  def before_setup
    super
    @tmpdir = Dir.mktmpdir
    @memo_dir = File.join(@tmpdir, "memo").freeze

    @dir_set = TEST_MEMO_DATA_SEED.to_set { |e| e[:dir] }

    @test_entries = []
    @test_repository_entries = []

    TEST_MEMO_DATA_SEED.each do |elem|
      dir_for_file = File.join(@memo_dir, elem[:dir])
      FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)
      # TEST_MEMO_DATA_SEEDのうち、memo readのテストのためにcontentのあるものはある程度の文字列を書き込む
      content = elem.key?(:content) ? elem[:content] : "# TEST #{elem[:dir]} #{elem[:filename]}\n"

      File.write(File.join(@memo_dir, elem[:dir], elem[:filename]), content)

      @test_entries << to_entry(@memo_dir, elem[:dir], elem[:filename])
      @test_repository_entries << to_repository_entry(@memo_dir, elem[:dir], elem[:filename])
    end

    # to_filesと生成ロジックが同じで、あんまりテストの意味がない
    @test_to_files = grouped_by_dir(@test_entries)
      .map do |key, entries|
        [Rainbow(key).green, entries.map(&:filename)]
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
