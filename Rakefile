# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create :test do |t|
  ENV['MEMO_CLI_RUNTIME_ENV'] = 'test'
end

task default: :test

namespace :format do
  desc 'rake rubocop -aを実行する'
  task :lint do
    sh 'bundle exec rubocop -a lib/ test/'
  end

  desc 'rake rubocop -Aを実行する'
  task :fix do
    sh 'bundle exec rubocop -A lib/ test/'
  end
end

# ここら辺をひとまとめにしてtest:cliかtest:e2eにする
namespace :cli do
  desc '開発中のmemo listを実行する'
  task :list do
    sh 'bundle exec ruby exe/memo list'
  end

  desc '開発中のmemo dirsを実行する'
  task :dirs do
    sh 'bundle exec ruby exe/memo dirs'
  end

  desc '開発中のmemo readを実行する'
  namespace :read do
    desc 'memo read grepを実行'
    task :positive1 do
      sh 'bundle exec ruby exe/memo read grep'
    end

    desc 'memo grepを実行。'
    task :positive2 do
      sh 'bundle exec ruby exe/memo grep'
    end

    desc 'memo readを実行する。失敗するはず。'
    task :negative do
      sh 'bundle exec ruby exe/memo read'
    end
  end
end
