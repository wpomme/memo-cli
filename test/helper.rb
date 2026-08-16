# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "memo"
require_relative "mock_seeds"

require "minitest/autorun"
require "minitest/spec"
require "minitest/expectations"
require "minitest/mock"

require "tmpdir"
require "fileutils"

module MemoTestLifecycleHooks
  include Memo::FileUtility

  def setup
    @tmpdir = Dir.mktmpdir

    # テスト環境ではMemo::Config.memo_dirを使わない
    @test_memo_dir = File.join(Dir.home, File.join(@tmpdir, "memo"))

    Memo::MockSeed::TEST_MEMO_DATA_SEED.each do |elem|
      dir_for_file = File.join(@test_memo_dir, elem[:dir])
      FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)

      File.write(File.join(@test_memo_dir, elem[:dir], "#{elem[:filename]}.md"), elem[:content])
    end

    @test_repo = Memo::Repository.new(@test_memo_dir)
    @test_seeds = @test_repo.instance_variable_get(:@seeds)

    @original_dir = Dir.pwd
    Dir.chdir(@tmpdir)
  end

  def teardown
    super
    Dir.chdir(@original_dir)
    FileUtils.remove_entry_secure(@tmpdir)
  end
end
