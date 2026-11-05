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

  def teardown
    # puts "#{name}: #{Sequel::DATABASES.size}" unless Sequel::DATABASES.empty?
    # super
  end

  def total_tag_size
    tag_size_by_filename = Memo::FileLoader.new.absolute_filename_to_tags.transform_values(&:size)
    tag_size_by_filename.values.inject(:+)
  end
end

module MemoLifecycleHooks
  def setup
    target_dir_hash = Memo::Config.target_dirs.map.with_index.to_h do |target_dir, index|
      [target_dir, File.join(Dir.home, "/var/test-target-dir-#{index}")]
    end
    @test_target_dirs = target_dir_hash.values
    @test_target_dirs.each do |dir|
      FileUtils.mkdir_p(dir)
    end

    @test_file_seeds = []

    Memo::MockSeed::TEST_MOCK_DATA_SEED.each do |seed|
      target_dir_hash.each do |orig_dir, test_dir|
        test_child_dir = File.join(test_dir, seed[:relative_path])
        FileUtils.mkdir_p(test_child_dir) unless FileTest.directory?(test_child_dir)

        is_dir_top = seed[:target_dir] == seed[:parent_directory]

        absolute_path = is_dir_top ? File.join(test_dir, "#{seed[:filename]}.md") : File.join(test_dir, seed[:relative_path], "#{seed[:filename]}.md")
        parent_directory = is_dir_top ? "#{test_dir}/" : File.join(test_dir, seed[:relative_path])

        next unless orig_dir == seed[:target_dir]

        File.write(File.join(test_dir, seed[:relative_path], "#{seed[:filename]}.md"), seed[:file_content])
        @test_file_seeds << Memo::Structure::FileSeed.new(
          test_dir,
          absolute_path,
          parent_directory,
          seed[:relative_path],
          seed[:filename],
          seed[:file_content],
          seed[:tags]
        )
      end
    end

    @fixed_mock_file = 'ls'
    @fixed_search_word = 'ls'
    @fixed_duplicated_filename = 'diff'
  end

  def teardown
    # ~/var/memo-cli-test-dirまでは削除して、~/var/は消さずに残しておく
    @test_target_dirs.each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
  end
end
