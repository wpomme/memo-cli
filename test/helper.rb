# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'memo'
require_relative 'mock_seeds'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/expectations'
require 'minitest/mock'

module MemoTestLifecycleHooks
  def setup
    # テスト環境ではMemo::Config.target_dirではないフォルダを作成して、それを使用する
    target_dir_hash = Memo::Config.target_dirs.map.with_index.to_h do |config_dir, index|
      [config_dir, File.join(Dir.home, "/var/test-target-dir-#{index}")]
    end
    @test_target_dirs = target_dir_hash.values
    @test_target_dirs.each do |dir|
      FileUtils.mkdir_p(dir)
    end

    @test_root_dirnames = @test_target_dirs.map { |dir| File.basename(dir) }

    Memo::MockSeed::TEST_MEMO_DATA_SEED.each do |seed|
      target_dir_hash.each do |orig_dir, test_dir|
        test_child_dir = File.join(test_dir, seed[:parent_dir])
        FileUtils.mkdir_p(test_child_dir) unless FileTest.directory?(test_child_dir)

        File.write(File.join(test_dir, seed[:parent_dir], "#{seed[:basename]}.md"), seed[:content]) if orig_dir == seed[:target_dir]
      end
    end

    @test_repo = Memo::Repository.new(@test_target_dirs)
    @test_seeds = @test_repo.instance_variable_get(:@seeds)

    @fixed_mock_file = 'ls'
    @fixed_search_word = 'ls'
    @fixed_duplicated_filename = 'mise'
  end

  def teardown
    # ~/var/memo-cli-test-dirまでは削除して、~/var/は消さずに残しておく
    @test_target_dirs.each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
  end
end
