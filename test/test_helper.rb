# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "memo"
require_relative "mock_seeds"

require "minitest/autorun"
require "minitest/spec"
require "minitest/expectations"

require "tmpdir"
require "fileutils"

module MemoTestLifecycleHooks
  # TODO: Memo::MockSeedを使ってLifecycleHooksを書き換える
  include Minitest::Test::LifecycleHooks
  include Memo::FileUtility

  # テストコード用のmemo_dirとその中身を作成する処理を行っている
  # TODO: tmpdirなどを使って、実際に実装のloadを使ってSeedを生成した方がいいかも
  def before_setup
    super

    # unless ENV.fetch('MEMO_CLI_RUNTIME_ENV') == 'test'
    #   puts 'Do not set MEMO_CLI_RUNTIME_ENV "test". Abort to execute test.'
    #   exit 1
    # end

    @tmpdir = Dir.mktmpdir
    @memo_dir = Memo::Env.memo_dir(File.join(@tmpdir, "memo").freeze)

    Memo::MockSeed::TEST_MEMO_DATA_SEED.each do |elem|
      dir_for_file = File.join(@memo_dir, elem[:dir])
      FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)

      File.write(File.join(@memo_dir, elem[:dir], "#{elem[:filename]}.md"), elem[:content])
    end

    # FIXME: newに@memo_dirを渡さないとモックデータとして成立しない
    @repo = Memo::Repository.new(@memo_dir)
    @test_seeds = @repo.seeds
    @dir_set =  @repo.dir_set

    @original_dir = Dir.pwd
    Dir.chdir(@tmpdir)
  end

  # テストコード用のmemo_dirとその中身を削除する処理
  def after_teardown
    super
    Dir.chdir(@original_dir)
    FileUtils.remove_entry_secure(@tmpdir)
  end
end
