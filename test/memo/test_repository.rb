# frozen_string_literal: true

require_relative "../helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      it 'テスト環境のとき、memo_dirは一時的に作成されたテスト用のディレクトリになる' do
        memo_file_set = @test_seeds.first.full_path.split("/").to_set
        memo_dir_set = @memo_dir.split("/").to_set

        # パスでsplitして集合にして、ディレクトリの方がファイルの方の部分集合であることを確かめれば良い
        assert memo_dir_set.subset?(memo_file_set)
      end

      it 'テスト環境の以外のとき、memo_dirはMemo::Env::MEMO_DIRとなる' do
        skip "TODO"
      end

      it '@seedsはMemo::Model::SeedのArrayである' do
        seeds = @repo.instance_variable_get(:@seeds)

        assert_instance_of Array, seeds
        seeds.each do |seed|
          assert_instance_of Memo::Model::Seed, seed
        end
      end

      it '@seeds.full_pathはREADME(.md)を含まない' do
        seeds = @repo.instance_variable_get(:@seeds)
        full_path = seeds.map(&:full_path)

        refute_includes full_path, "README"
        refute_includes full_path, "README.md"
      end

      it '@seeds:full_path は絶対パスである' do
        seeds = @repo.instance_variable_get(:@seeds)
        full_paths = seeds.map(&:full_path)

        full_paths.each do |full_path|
          assert File.absolute_path?(full_path)
        end
      end
    end

    describe '#dir_set' do
      it "モックデータと実際のdir_setが同じであること" do
        expected = @repo.dir_set
        actual = Memo::MockSeed::TEST_MEMO_DATA_SEED.map { |seed_hash| seed_hash[:dir] }.uniq.to_set

        _(expected).must_equal(actual)
      end
    end

    describe '#find' do
      it "memoの中に存在するファイルが見つかった場合は、最初に見つかったSeedを返す" do
        word = 'push'
        expected = @repo.find(word)
        actual = @test_seeds.find { |seed| seed.filename == word }

        assert_equal expected, actual
      end

      it "memoの中に存在しないwordが入力された場合は、nilを返す" do
        word = 'invalid_word'
        expected = @repo.find(word)

        assert_nil expected
      end

      it "wordがnilの場合も、nilを返す" do
        word = nil
        expected = @repo.find(word)

        assert_nil expected
      end
    end

    describe '#read' do
      it "seedが存在すれば、そのファイルを全文表示する。、" do
        expected_seed = @test_seeds.find { |seed| seed.filename == "diff" }
        expected = @repo.read(expected_seed)

        actual = Memo::MockSeed::TEST_DIFF_FILE_CONTENT

        assert_equal expected, actual.split("\n")
      end

      it "nilが与えられたら、そのままnilを返す" do
        expected = @repo.read(nil)

        assert_nil expected
      end
    end

    describe '#search_all' do
      it "検索結果の配列を返す" do
        search_word = 'diff'
        expected = @repo.search_all(search_word)

        actual = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
          rel_path = File.join(seed[:dir], "#{seed[:filename]}.md")
          ret = seed[:content]
            .split("\n")
            .each_with_index
            .filter_map do |line, index|
              Memo::Model::SearchLine.new(path: rel_path, line_number: index + 1, line: line) if line.include?(search_word)
            end
          ret unless ret.empty?
        end

        # search_allの戻り値は二重配列でそれぞれの配列はファイルごとにグループ化されている
        _(expected).must_be_instance_of(Array)
        _(expected.first).must_be_instance_of(Array)
        _(expected.first.first).must_be_instance_of(Memo::Model::SearchLine)
        # 要素が同じなら順番は別で構わない
        _(expected.to_set).must_equal(actual.to_set)
      end

      it "検索してもヒットしなかった場合はnilを返す" do
        search_word = 'hikkakaranasounakotoba'
        expected = @repo.search_all(search_word)

        assert_nil expected
      end
    end
  end
end
