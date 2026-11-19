# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'memo'
require_relative 'mock_seeds'
require 'fileutils'

class TestMemoDataCreator
  def initialize
    this_repo_dir = `git rev-parse --show-toplevel`.chomp
    mock_target_dirs = Memo::Config.target_dirs << File.join(this_repo_dir, '/mock-data/')
    @target_dir_hash = mock_target_dirs.map.with_index.to_h do |target_dir, index|
      [target_dir, File.join(this_repo_dir, "/var/test-target-dir-#{index}")]
    end

    @test_target_dirs = @target_dir_hash.values
  end

  def create
    create_dirs
    create_files
  end

  # [this-repo]/var/直下のテストデータを削除するときに使う
  # [this-repo]/var/ディレクトリは残しておく
  def delete
    @test_target_dirs.each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
  end

  private

  def create_dirs
    @test_target_dirs.each do |dir|
      FileUtils.mkdir_p(dir)
    end
  end

  def create_files
    Memo::MockSeed::TEST_MOCK_DATA_SEED.each do |seed|
      @target_dir_hash.each do |orig_dir, test_dir|
        test_child_dir = File.join(test_dir, seed[:relative_path])
        FileUtils.mkdir_p(test_child_dir) unless FileTest.directory?(test_child_dir)

        next unless orig_dir == seed[:target_dir]

        File.write(File.join(test_dir, seed[:relative_path], "#{seed[:filename]}.md"), seed[:file_content])
      end
    end
  end
end
