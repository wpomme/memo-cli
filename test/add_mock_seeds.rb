# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'memo'

file_loader = Memo::FileLoader.new

# テストのために固定のファイルを選択しておく
fixed_duplicated_filename = 'diff'
fixed_mock_file = 'ls'

seeds = file_loader.file_seeds.filter.with_index do |file_seeds, idx|
  idx.modulo(2).zero? || [fixed_duplicated_filename, fixed_mock_file].include?(file_seeds[:filename])
end
# uniq!

## ファイル名の一覧
filenames = seeds.map { |seed| seed[:filename] }

duplicated_seeds = seeds.filter do |seed|
  filenames.count(seed[:filename]) > 1
end

## モックデータ作成用のコマンド
## TEST_MOCK_DATAの元となるRubyのArray<Hash>とヒアドキュメントを返す
mock_seeds = seeds.map do |seed|
  content = seed[:file_content].split("\n")
  filename = duplicated_seeds.include?(seed) ? seed[:parent_rel_path].sub('.md', '').upcase.sub('-', '_').gsub('/', '_') : seed[:filename].upcase.gsub('-', '_')
  val_name = "TEST_#{filename}_FILE_CONTENT"
  label = "#{filename}_FILE"
  heredoc = ["#{val_name} = <<~#{label}"] + content + [label] + ["\n"]
  {
    mock_seed: {
      target_dir: seed[:target_dir],
      absolute_path: seed[:absolute_path],
      parent_directory: seed[:parent_directory],
      parent_rel_path: seed[:parent_rel_path],
      filename: seed[:filename],
      file_content: val_name.to_sym,
      tags: seed[:tags]
    },
    heredoc: heredoc
  }
end

output = './test/mock_seeds.rb'

File.open(output, 'w') do |file|
  file.puts(['module Memo', 'module MockSeed'])
  mock_seeds.each do |seed|
    file.puts(seed[:heredoc])
  end

  test_mock_data_seed = mock_seeds.map do |seed|
    <<~MEMO_DATA
      {
        target_dir: '#{seed[:mock_seed][:target_dir]}',
        absolute_path: '#{seed[:mock_seed][:absolute_path]}',
        parent_directory: '#{seed[:mock_seed][:parent_directory]}',
        parent_rel_path: '#{seed[:mock_seed][:parent_rel_path]}',
        filename: '#{seed[:mock_seed][:filename]}',
        file_content: #{seed[:mock_seed][:file_content]},
        tags: #{seed[:mock_seed][:tags]},
      },
    MEMO_DATA
  end

  file.puts ["\n"] + ['TEST_MOCK_DATA_SEED = ['] + test_mock_data_seed + [']', 'end', 'end']
end
