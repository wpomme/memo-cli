# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "memo"
require_relative "mock_seeds"

require "minitest/autorun"
require "minitest/spec"
require "minitest/expectations"

require "tmpdir"
require "fileutils"

# 環境変数MEMO_CLI_RUNTIME_ENVの値によりテストケースを作成したい場合はこちらを使う
module MemoTestRuntimeEnvHooks
  def setup
    @original_runtime_env = ENV.fetch('MEMO_CLI_RUNTIME_ENV', nil)

    @tmpdir = Dir.mktmpdir
    @memo_dir = File.join(@tmpdir, "memo")

    @original_dir = Dir.pwd
    Dir.chdir(@tmpdir)
  end

  def teardown
    if @original_runtime_env.nil?
      ENV.delete('MEMO_CLI_RUNTIME_ENV')
    else
      ENV['MEMO_CLI_RUNTIME_ENV'] = @original_runtime_env
    end

    Dir.chdir(@original_dir)
    FileUtils.remove_entry_secure(@tmpdir)
  end
end

module MemoTestLifecycleHooks
  include Memo::FileUtility

  def setup
    # 環境変数MEMO_CLI_RUNTIME_ENVの値がtestでなければテストを中断する
    if ENV.fetch('MEMO_CLI_RUNTIME_ENV') != 'test'
      puts "Does not set MEMO_CLI_RUNTIME_ENV 'test'. Abort to execute test."
      exit 1
    end

    @tmpdir = Dir.mktmpdir
    @memo_dir = Memo::Env.memo_dir(File.join(@tmpdir, "memo").freeze)

    Memo::MockSeed::TEST_MEMO_DATA_SEED.each do |elem|
      dir_for_file = File.join(@memo_dir, elem[:dir])
      FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)

      File.write(File.join(@memo_dir, elem[:dir], "#{elem[:filename]}.md"), elem[:content])
    end

    @repo = Memo::Repository.new(@memo_dir)
    @test_seeds = @repo.seeds
    @dir_set =  @repo.dir_set

    @original_dir = Dir.pwd
    Dir.chdir(@tmpdir)
  end

  def teardown
    super
    Dir.chdir(@original_dir)
    FileUtils.remove_entry_secure(@tmpdir)
  end
end
