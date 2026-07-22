# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create :test do |_t|
  ENV['MEMO_CLI_RUNTIME_ENV'] = 'test'
end

task default: :test

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

namespace :mock do
  desc '元データからモックデータを作成する'
  task :make do
    # メモフォルダへの絶対パスを返す
    dir = Memo::Env.to_memo_dir

    # Repositoryのオブジェクトを作成する
    repo = Memo::Repository.new(dir)

    # モックデータ作成のために実データseedsを任意の倍数で絞り込んで取得する
    # なお、モックデータ取得のためにattr_reader :seedsとする必要がある
    seeds = repo.seeds.filter.each_with_index { |_e, i| i.modulo(4).zero? }

    ## モックデータ作成用のコマンド
    ## TEST_MEMO_DATA_SEEDの元となるRubyのArray<Hash>とヒアドキュメントを返す
    mock_seeds = seeds.map do |seed|
      content = Memo::Repository.read(seed)
      filename = seed.filename.upcase.tr("-", "_")
      val_name = "TEST_#{filename}_FILE_CONTENT"
      label = "#{filename}_FILE"
      heredoc = ["#{val_name} = <<~#{label}"] + content + [label] + ["\n"]
      {
        mock_seed: { dir: seed.dir, filename: seed.filename, content: val_name.to_sym },
        heredoc: heredoc
      }
    end

    # test/でなくlib/に入れておく
    output = "lib/memo/mock_seed.rb"

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
