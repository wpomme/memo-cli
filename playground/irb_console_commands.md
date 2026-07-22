## bundle exec irb で調べたこと
- 準備
```bash
## ログイン
bundle exec irb
```

## irbコンソールの中
```irb
# メモフォルダへの絶対パスを返す
dir = Memo::Env.to_memo_dir

# Repositoryのオブジェクトも作成しておく
repo = Memo::Repository.new(dir)

# モックデータ取得のためにattr_reader :seedsとしてある
# モックデータ作成のためにseedsを取得する
seeds = repo.seeds
```

## `seeds`についての調査
```irb
## このseedsは配列ではないが、Enumerableではある
seeds.is_a?(Array)
=> true
seeds.is_a?(Object)
=> true
seeds.is_a?(Class)
=> false

seeds.class
=> Array

## seedはMemo::Model::Seedクラスのインスタンスである
seeds.first.instance_of?(Memo::Model::Seed)

## オブジェクトのインスタンス変数(例: @foo)はinstance_variablesで調べられる
## 現状、
```ruby
repo.instance_variables
=> [:@seeds]
```

## `seeds_grouped_by_dir`についての調査
```irb
## filesをdir名でgroupかしたものの調査
## 返り値をHashにして、値をファイル名の配列か集合にしたかったので
## 次のコマンドだと値が配列になっているものが帰ってくる
repo.seeds_grouped_by_dir(repo)["git"].map(&:filename)

## 最後にto_setを付ければ、値が集合になる
repo.seeds_grouped_by_dir(repo)["git"].map(&:filename).to_set

## dirでグループ化したデータ構造をStructに持たせる
## まず、グループ化したデータ構造を調べる
grouped = repo.seeds_grouped_by_dir(repo)

## 次のようなものが良さそう
def new_grouped_files(grouped)
  grouped.map do |dir, seed|
    Memo::FilesGroupedByDir.new(
      dir: dir,
      file_hash: seed.map{ |seed| {seed.filename => seed.full_path} }
    )
  end
end
```

## Data, Structオブジェクトの使い方に慣れてテストデータを新しく作り直したい
```ruby
## 実データからサンプルデータを取得(四の倍数のデータのみ取得)
seeds = repo.seeds.filter.each_with_index{|e, i| (i).modulo(4).zero? }

## contentをヒアドキュメント形式にして出力したい
### 試しにgrepで作成
grep_seed = repo.find("grep")
grep_content = Memo::Repository.read(grep_seed)
puts ["TEST_GREP_FILE_CONTENT = <<~GREP_FILE"].append(grep_content).append("GREP_FILE")

### TODO: grepのヒアドキュメントを元に、実データの1/4くらいのモックデータを作成する

## モックデータ作成用のコマンド
mock_seeds = seeds.map do |seed|
  content = Memo::Repository.read(seed)
  filename = seed.filename.upcase.tr("-", "_")
  val_name = "TEST_#{filename}_FILE_CONTENT"
  label = "#{filename}_FILE"
  heredoc = ["#{val_name} = <<~#{label}"] + content + [label] + ["\n"]
  {
    mock_seed: { dir: seed.dir, filename: seed.filename, content: val_name},
    heredoc: heredoc
  }
end

# モックデータ作成: Fakerを使えば良さそう
# https://github.com/faker-ruby/faker
# それかRakefileでファイルを生成すると良さそう
# contentが引数に取るヒアドキュメント
# ヒアドキュメントの方は正確に出力できている
File.open("test/test_mock_seeds.rb", "w") do |file|
  mock_seeds.each do |seed|
    file.puts(seed[:heredoc])
  end

  mock_seeds.each do |seed|
    file.print(seed[:mock_seed])
  end
end

# 今のTEST_MEMO_DATA_SEEDに対応
# contentのval_nameは引用符を抜いてファイルに出力してほしい
# 他、TEST_MEMO_DATA_SEED = ... の形で出力してほしいなど
mock_seeds.map{|seed| seed[:mock_seed]}

```

