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
  sh 'rake mock_make && bundle exec rubocop -A test/mock_seeds.rb '
end

desc '元データからモックデータを作成する'
task :new_mock_data do
  sh 'ruby ./test/add_mock_seeds.rb'
  sh 'bundle exec rubocop -A test/new_mock_seeds.rb'
end

# rake mockでmock_seeds.rbを作成
# 作成後は、rake fixを実行して、重複したヒアドキュメントがあれば手動で直す
desc '元データからモックデータを作成する'
task :mock_make do
  # Repositoryのオブジェクトを作成する
  repo = Memo::Repository.new(Memo::Config.target_dirs)

  # ファイル名の重複しているものを指定する。実際のメモフォルダで重複がなくなったら、この値を変える必要がある。
  fixed_duplicated_filename = 'mise'

  seeds = repo.instance_variable_get(:@file_seeds).filter { |seed| seed.basename == fixed_duplicated_filename }

  # モックデータ作成のために実データseedsを任意の倍数で絞り込んで取得する
  seeds.concat(repo.instance_variable_get(:@file_seeds).filter.each_with_index { |_e, i| i.modulo(2).zero? })
    .uniq!

  # テストのために固定のseedを作成する
  fixed_mock_file = 'ls'
  seeds.concat(repo.find_files(fixed_mock_file)) if seeds.none? { |seed| seed.basename == fixed_mock_file }

  ## ファイル名の一覧を
  basenames = seeds.map(&:basename)

  ## 重複しているファイル名と、重複しているSeedを抽出する
  duplicated_seeds = seeds.filter { |seed| basenames.count(seed['basename']) > 1 }

  ## モックデータ作成用のコマンド
  ## TEST_MEMO_DATA_SEEDの元となるRubyのArray<Hash>とヒアドキュメントを返す
  mock_seeds = seeds.map do |seed|
    content = Memo::Service.read(seed)
    basename = duplicated_seeds.include?(seed) ? seed.rel_path.sub('.md', '').upcase.sub('-', '_').gsub('/', '_') : seed.basename.upcase.gsub('-', '_')
    val_name = "TEST_#{basename}_FILE_CONTENT"
    label = "#{basename}_FILE"
    heredoc = ["#{val_name} = <<~#{label}"] + content + [label] + ["\n"]
    {
      mock_seed: { target_dir: seed.target_dir, parent_dir: seed.parent_dir, basename: seed.basename, content: val_name.to_sym },
      heredoc: heredoc
    }
  end

  output = 'test/mock_seeds.rb'

  File.open(output, 'w') do |file|
    file.puts(['module Memo', 'module MockSeed'])
    mock_seeds.each do |seed|
      file.puts(seed[:heredoc])
    end

    test_memo_data_seed = mock_seeds.map do |seed|
      <<~MEMO_DATA
        {
          target_dir: "#{seed[:mock_seed][:target_dir]}",
          parent_dir: "#{seed[:mock_seed][:parent_dir]}",
          basename: "#{seed[:mock_seed][:basename]}",
          content: #{seed[:mock_seed][:content]}
        },
      MEMO_DATA
    end

    file.puts ["\n"] + ['TEST_MEMO_DATA_SEED = ['] + test_memo_data_seed + [']', 'end', 'end']
  end
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
