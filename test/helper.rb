# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "memo"
require_relative "mock_seeds"

require "minitest/autorun"
require "minitest/spec"
require "minitest/expectations"
require "minitest/mock"

module MemoTestLifecycleHooks
  def setup
    # テスト環境ではMemo::Config.memo_dirを使わない
    @test_memo_dir = File.join(Dir.home, "/var/test-memo-dir")
    FileUtils.mkdir_p(@test_memo_dir)

    @test_root_dirname = File.basename(@test_memo_dir)

    Memo::MockSeed::TEST_MEMO_DATA_SEED.each do |elem|
      dir_for_file = File.join(@test_memo_dir, elem[:dir])
      FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)

      File.write(File.join(@test_memo_dir, elem[:dir], "#{elem[:filename]}.md"), elem[:content])
    end

    @test_repo = Memo::Repository.new(@test_memo_dir)
    @test_seeds = @test_repo.instance_variable_get(:@seeds)
  end

  def teardown
    # ~/var/memo-cli-test-dirまでは削除して、~/var/は消さずに残しておく
    FileUtils.remove_entry_secure(@test_memo_dir)
  end
end
