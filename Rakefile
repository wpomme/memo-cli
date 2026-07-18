# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

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

namespace :cli do
  desc '開発中のmemo listを実行する'
  task :list do
    sh 'bundle exec ruby exe/memo list'
  end

  desc '開発中のmemo dirsを実行する'
  task :dirs do
    sh 'bundle exec ruby exe/memo dirs'
  end
end
