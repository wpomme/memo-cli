# frozen_string_literal: true

require_relative "../helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      it 'テスト環境のとき、memo_dirは一時的に作成されたテスト用のディレクトリになる' do
        memo_file_set = @test_seeds.first.full_path.split("/").to_set
        memo_dir_set = @test_memo_dir.split("/").to_set

        # パスでsplitして集合にして、ディレクトリの方がファイルの方の部分集合であることを確かめれば良い
        assert memo_dir_set.subset?(memo_file_set)
      end

      it '@seedsの配列の要素はMemo::Model::Seedである' do
        seeds = @test_repo.instance_variable_get(:@seeds)
        expected = seeds.all?(Memo::Model::Seed)

        _(true).must_equal(expected)
      end

      # TODO: モックデータにREADME.md用のデータを作成する
      it '@seeds.full_pathはREADME(.md)を含まない' do
        seeds = @test_repo.instance_variable_get(:@seeds)
        full_path = seeds.map(&:full_path)

        refute_includes full_path, "README"
        refute_includes full_path, "README.md"
      end

      it '@seeds:full_path は絶対パスである' do
        seeds = @test_repo.instance_variable_get(:@seeds)
        full_paths = seeds.map(&:full_path)

        full_paths.each do |full_path|
          assert File.absolute_path?(full_path)
        end
      end

      it '対象ディレクトリの最上位にあるメモのdirは、そのメモが保存されているディレクトリ名になる' do
        skip "TODO: @fixed_mock_file_under_root_dirを作成する"
      end
    end

    describe '#dir_set' do
      it "dir_setの中に対象の最上位のディレクトリが含まれていること" do
        dir_set = @test_repo.dir_set

        _(dir_set.include?(@test_root_dirname)).must_equal(true)
      end
      it "モックデータと実際のdir_setが同じであること" do
        actual = @test_repo.dir_set
        expected = Dir.glob("**/*/", base: @test_memo_dir)
          .to_set { |dir| dir.rstrip("/") }
          .add(@test_root_dirname)

        _(actual).must_equal(expected)
      end
    end

    describe '#find' do
      describe '戻り値の型検査' do
        describe "検索文字列と一致するファイル名が見つかった場合は、Seedの一次元配列を返す" do
          it "ファイル名が一件見つかった場合" do
            word = @fixed_search_word
            ret = @test_repo.find(word)
            expected = ret.all?(Memo::Model::Seed)

            _(true).must_equal(expected)
          end

          it "ファイル名が複数件見つかった場合" do
            word = 'mise'
            ret = @test_repo.find(word)
            expected = ret.all?(Memo::Model::Seed)

            _(true).must_equal(expected)
          end
        end

        describe "検索文字列と一致するファイル名が見つからなかった場合は、空の配列を返す" do
          it "メモの中に存在しない検索文字列が入力された場合" do
            word = 'invalid_word'
            expected = @test_repo.find(word)

            _([]).must_equal(expected)
          end
        end
      end

      describe "戻り値の値検査" do
        describe "検索文字列と一致するファイル名が見つかった場合は、そのSeedの一次元配列を返す" do
          it "ファイル名が一件見つかった場合" do
            word = @fixed_search_word
            expected = @test_repo.find(word)
            actual = @test_seeds.filter { |seed| seed.basename == word }

            _(actual).must_equal(expected)
          end

          it "ファイル名が複数件見つかった場合" do
            word = 'mise'
            expected = @test_repo.find(word)
            actual = @test_seeds.filter { |seed| seed.basename == word }

            _(actual).must_equal(expected)
          end
        end
      end
    end

    describe "#grouped_ls" do
      describe "戻り値の型検査" do
        it "戻り値はHashである" do
          result = @test_repo.grouped_ls

          _(result).must_be_instance_of Hash
        end

        it "キーは文字列となる" do
          result = @test_repo.grouped_ls

          actual = result.keys.all?(String)

          _(actual).must_equal true
        end

        it "値はSeedの一次元配列となる" do
          result = @test_repo.grouped_ls

          actual = result.values.all? do |seeds|
            seeds.all?(Memo::Model::Seed)
          end

          _(actual).must_equal true
        end
      end

      describe "戻り値の値検査" do
        it "キーが対象のディレクトリの最上位であるとき、その値のparent_dirは全てキーと同じ値になり、その値はディレクトリの最上位を表す文字列となる" do
          test_walk_seed_hash = @test_repo.grouped_ls

          values = test_walk_seed_hash[@test_root_dirname]

          actual = values.all? do |seed|
            seed.parent_dir == @test_root_dirname
          end

          _(true).must_equal(actual)
        end
      end
    end

    describe '#search_all' do
      describe '戻り値の型検査' do
        it "検索結果は二重配列で要素はMemo::Model::SearchLineである" do
          search_word = @fixed_search_word
          result = @test_repo.search_all(search_word)

          expected = result.all? do |memo|
            memo.all?(Memo::Model::SearchLine)
          end

          _(true).must_equal(expected)
        end

        it "検索結果が空の場合は、空の二重配列を返す" do
          search_word = 'hikkakaranasounakotoba'
          result = @test_repo.search_all(search_word)

          expected = result.all? do |memo|
            memo.all?(&:empty?)
          end

          _(true).must_equal(expected)
        end
      end

      describe '戻り値の値検査' do
        it "モックデータから作成した検索結果と要素が同じである" do
          search_word = @fixed_search_word
          expected = @test_repo.search_all(search_word)

          actual = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
            rel_path = File.join(seed[:parent_dir], "#{seed[:basename]}.md")
            seed[:content]
              .split("\n")
              .each_with_index
              .filter_map do |line, index|
                Memo::Model::SearchLine.new(path: rel_path, line_number: index + 1, line: line) if line.include?(search_word)
              end
          end

          _(expected.to_set).must_equal(actual.to_set)
        end
      end
    end
  end
end
