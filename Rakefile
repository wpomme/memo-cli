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

cmd_tasks = {
  list: [
    {
      name: 'noargs',
      cmd: 'list'
    },
    {
      name: 'dirs',
      cmd: 'list cli'
    }
  ],
  dirs: [
    {
      name: 'default',
      cmd: 'dirs'
    }
  ],
  read: [
    {
      name: 'default',
      cmd: 'read ls'
    },
    {
      name: 'memo',
      cmd: 'ls'
    }
  ],
  search: [
    {
      name: 'default',
      cmd: 'search diff'
    }
  ]
}

desc 'memo cliの正常系が成功するかテストする'
task :e2e do
  cmd_tasks.each do |cmd_name, task_list|
    task_list.each do |task_hash|
      sh("rake cli:#{cmd_name}:#{task_hash[:name]}", verbose: false)
    end
  end
end

namespace :cli do
  cmd_tasks.each do |cmd_name, task_list|
    namespace cmd_name do
      desc "#{cmd_name}を実行する"
      task_list.each do |task_hash|
        desc "memo #{task_hash[:cmd]}を実行する"
        task task_hash[:name] do
          IO.popen((%w[bundle exec ruby exe/memo] << task_hash[:cmd].split).flatten) do |pipe|
            puts "Success: memo #{task_hash[:cmd]}" if $CHILD_STATUS.success?
            pipe.close
          end
        end
      end
    end
  end
end
