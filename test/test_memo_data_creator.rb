# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'memo'
require_relative 'mock_seeds'
require 'fileutils'

class TestMemoDataCreator
  def initialize
    this_repo_dir = `git rev-parse --show-toplevel`.chomp
    mock_target_dirs = [File.join(this_repo_dir, '/mock-data/')].concat(Memo::Config.target_dirs)
    @target_dir_hash = mock_target_dirs.map.with_index(1).to_h do |target_dir, index|
      basename = File.basename(target_dir)
      [target_dir, File.join(this_repo_dir, '/var/', "test#{index}-#{basename}")]
    end

    @test_target_dirs = @target_dir_hash.values
  end

  def create
    delete
    create_dirs
    create_files
  end

  # NOTE: var/以下の全てのディレクトリを消さないことに注意すること
  # createの方を更新してからdeleteを実行してもディレクトリが消えない
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
        next unless orig_dir == seed[:target_dir]

        child_dir = File.join(test_dir, seed[:relative_path])

        FileUtils.mkdir_p(child_dir) unless FileTest.directory?(child_dir)
        File.write(File.join(test_dir, seed[:relative_path], "#{seed[:filename]}.md"), seed[:file_content])
      end
    end
  end
end
