# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rake/TestTask"
require "rubocop/rake_task"

Minitest::TestTask.create

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.pattern = 'test/**/test_*.rb'
end

task default: :test

desc 'rake rubocop -aを実行する'
task :format do
  sh 'rake rubocop:autocorrect_all'
end

desc 'rake rubocop -Aを実行する'
task :fix do
  sh 'rake rubocop:autocorrect_all'
end

desc '開発中のmemo listを実行する'
task :list do
  sh 'bundle exec ruby exe/memo list'
end

desc '開発中のmemo dirsを実行する'
task :dirs do
  sh 'bundle exec ruby exe/memo dirs'
end
