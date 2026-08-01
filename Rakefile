# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create :test

task default: :test

desc 'irbにログインする'
task :console do
  sh "bundle exec console"
end

namespace :test do
  desc 'ファイルごとにテストする'
  task :file do
    Dir.glob("test/**/test_*.rb").each do |path|
      puts "TEST: #{path}"
      sh "bundle exec ruby -Itest #{path}"
    end
  end
end

namespace :format do
  desc 'rake rubocop -aを実行する'
  task :lint do
    sh 'bundle exec rubocop -a lib/ test/ playground/*.rb Rakefile'
  end

  desc 'rake rubocop -Aを実行する'
  task :fix do
    sh 'bundle exec rubocop -A lib/ test/ playground/*.rb Rakefile'
  end
end

# rake mockでmock_seeds.rbを作成
# 作成後は、rake format:fixを実行して、重複したヒアドキュメントがあれば手動で直す
namespace :mock do
  desc '元データからモックデータを作成する'
  task :make do
    # メモフォルダへの絶対パスを返す
    dir = Memo::Config.memo_dir

    # Repositoryのオブジェクトを作成する
    repo = Memo::Repository.new(dir)

    # モックデータ作成のために実データseedsを任意の倍数で絞り込んで取得する
    seeds = repo.seeds.filter.each_with_index { |_e, i| i.modulo(4).zero? }
    # テストのために固定のseedを作成する
    fixed_mock_file = "diff"
    seeds.push(repo.find(fixed_mock_file)) if repo.seeds.find { |seed| seed.filename == fixed_mock_file }

    ## モックデータ作成用のコマンド
    ## TEST_MEMO_DATA_SEEDの元となるRubyのArray<Hash>とヒアドキュメントを返す
    mock_seeds = seeds.map do |seed|
      content = repo.read(seed)
      filename = seed.filename.upcase.tr("-", "_")
      val_name = "TEST_#{filename}_FILE_CONTENT"
      label = "#{filename}_FILE"
      heredoc = ["#{val_name} = <<~#{label}"] + content + [label] + ["\n"]
      {
        mock_seed: { dir: seed.dir, filename: seed.filename, content: val_name.to_sym },
        heredoc: heredoc
      }
    end

    output = "test/mock_seeds.rb"

    File.open(output, "w") do |file|
      file.puts(["module Memo", "module MockSeed"])
      mock_seeds.each do |seed|
        file.puts(seed[:heredoc])
      end

      test_memo_data_seed = mock_seeds.map do |seed|
        <<~MEMO_DATA
          {
            dir: "#{seed[:mock_seed][:dir]}",
            filename: "#{seed[:mock_seed][:filename]}",
            content: #{seed[:mock_seed][:content]}
          },
        MEMO_DATA
      end

      file.puts ["\n"] + ["TEST_MEMO_DATA_SEED = ["] + test_memo_data_seed + [']', 'end', 'end']
    end
  end
end

# ここら辺をひとまとめにしてtest:cliかtest:e2eにする
namespace :cli do
  desc '開発中のmemo listを実行する'
  task :list do
    sh 'bundle exec ruby exe/memo list 2>&1 > /dev/null || echo "Failed: memo list"'
  end

  desc '開発中のmemo dirsを実行する'
  task :dirs do
    sh 'bundle exec ruby exe/memo dirs'
  end

  desc '開発中のmemo readを実行する'
  namespace :read do
    desc 'memo read grepを実行'
    task :positive1 do
      sh 'bundle exec ruby exe/memo search'
    end

    desc 'memo grepを実行。'
    task :positive2 do
      sh 'bundle exec ruby exe/memo search'
    end

    desc 'memo readを実行する。失敗するはず。'
    task :negative do
      sh 'bundle exec ruby exe/memo read'
    end
  end
end
