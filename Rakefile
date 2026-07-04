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

desc '開発中のmemo list を実行する'
task :list do
  sh 'bundle exec ruby exe/memo list'
end

desc '開発中のmemo dirs を実行する'
task :dirs do
  sh 'bundle exec ruby exe/memo dirs'
end
