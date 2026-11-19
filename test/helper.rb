# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'memo'
require_relative 'mock_seeds'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/expectations'
require 'minitest/mock'

module MemoDBTestLifecycleHooks
  def setup
    super
    test_database_filename = 'memo_test.db'
    @test_database_path = Memo::Config.target_database(database_filename: test_database_filename)
    @db = Memo::Database.db(database_path: @test_database_path)
    Memo::Database::Setup.new(@db).prepare
  end

  # def teardown
  #   puts "#{name}: #{Sequel::DATABASES.size}" unless Sequel::DATABASES.empty?
  #   super
  # end

  def total_tag_size
    tag_size_by_filename = Memo::FileLoader.new.absolute_filename_to_tags.transform_values(&:size)
    tag_size_by_filename.values.inject(:+)
  end
end

module MemoLifecycleHooks
  def setup
    super
    # TODO: パフォーマンスのために`git rev-parse --show-toplevel`の結果は共有したい
    # TODO: test_memo_data_creatorのnewと共用にする。ロジックが同じで、片方を変更すると、テストが失敗するため
    # this_repo_dir = `git rev-parse --show-toplevel`.chomp
    this_repo_dir = '/Users/hy/repo/memo-cli'
    mock_target_dir = File.join(this_repo_dir, '/mock-data/')
    mock_target_dirs = [mock_target_dir].concat(Memo::Config.target_dirs)
    @target_dir_hash = mock_target_dirs.map.with_index(1).to_h do |target_dir, index|
      basename = File.basename(target_dir)
      [target_dir, File.join(this_repo_dir, '/var/', "test#{index}-#{basename}")]
    end

    @orig_target_dirs = @target_dir_hash.keys
    @test_target_dirs = @target_dir_hash.values

    @test_mock_target_dir = @target_dir_hash[mock_target_dir]
    @test_mock_dir = 'mock-dir/'
    # TODO: mock_filenameにする
    @fixed_filename = 'mock-file'
    # TODO: mock_duplicated_filenameにする
    @fixed_duplicated_filename = 'mock-dup-file'
  end
end
