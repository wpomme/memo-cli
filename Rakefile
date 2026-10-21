# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'
require 'English'

Minitest::TestTask.create :test

task default: :test

namespace :test do
  desc 'ファイルごとにテストする'
  task :file do
    Dir.glob('test/**/test_*.rb').each do |path|
      puts "TEST: #{path}"
      sh "bundle exec ruby -Itest #{path}"
    end
  end
end

desc 'rake rubocop -aを実行する'
task :lint do
  sh 'bundle exec rubocop -a lib/ test/ playground/*.rb Rakefile'
end

desc 'rake rubocop -Aを実行する'
task :fix do
  sh 'bundle exec rubocop -A lib/ test/ playground/*.rb Rakefile'
end

desc 'test/mock_seeds.rbにモックデータを作成する'
task :seeds do
  sh 'ruby ./test/add_mock_seeds.rb'
  sh 'bundle exec rubocop -A test/new_mock_seeds.rb'
end

namespace :db do
  desc 'DBにデータを挿入する'
  task :seeds do
    db = Memo::Database.db
    Memo::Database::Setup.new(db).execute
  end

  desc 'DBにテストデータを挿入する'
  task :seeds_test do
    database_path = Memo::Config.target_database(database_filename: 'memo_test.db')
    db = Memo::Database.db(database_path: database_path)
    Memo::Database::Setup.new(db).execute
  end
end

desc 'memo cliが成功するかテストする'
task :e2e do
  sh 'bundle exec exe/memo > /dev/null'
  sh 'bundle exec exe/memo ls > /dev/null'
  sh 'bundle exec exe/memo read 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo read ls > /dev/null'
  sh 'bundle exec exe/memo read does_not_exist_files 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo search 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo search ls > /dev/null'
  sh 'bundle exec exe/memo search does_not_exist_search_strings 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo tag 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo tag CLI > /dev/null'
  sh 'bundle exec exe/memo tag does_not_exist_search_strings 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo dirs > /dev/null'
  sh 'bundle exec exe/memo dirs foo 2>&1 > /dev/null || true'
  sh 'bundle exec exe/memo tags > /dev/null'
  sh 'bundle exec exe/memo tags -n > /dev/null'
  sh 'bundle exec exe/memo list > /dev/null'
  sh 'bundle exec exe/memo list cli/ > /dev/null'
end
