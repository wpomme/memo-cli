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
      it "モックデータと実際のdir_setが同じであること" do
        expected = @test_repo.dir_set
        actual = Dir.glob("**/*/", base: @test_memo_dir).to_set { |dir| dir.rstrip("/") }.add(@test_root_dirname)

        _(actual).must_equal(expected)
      end
    end

    describe '#dir_seeds' do
      it '戻り値はDirSeedの一次元配列となる' do
        expected = @test_repo.dir_seeds.all?(Memo::Model::DirSeed)
        _(true).must_equal(expected)
      end

      it 'DirSeedのbasenameがディレクトリのトップのとき、parent_dirはnilとなる' do
        root_dir_seed = @test_repo.dir_seeds.find { |seed| seed.basename == @test_root_dirname }
        _(root_dir_seed.parent_dir).must_be_nil
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

    describe '#grouped_file_list' do
      describe '戻り値の型検査' do
        it "GroupedFileListの一次元配列を返す" do
          ret = @test_repo.grouped_file_list
          expected = ret.all?(Memo::Model::GroupedFileList)

          _(true).must_equal(expected)
        end
      end

      describe '戻り値の値検査' do
        it "モックデータの値と同じであること" do
          expected = @test_repo.grouped_file_list

          actual = @test_seeds.group_by(&:parent_dir).map do |dir, seed|
            Memo::Model::GroupedFileList.new(
              dir: dir,
              filenames: seed.map(&:basename)
            )
          end

          _(actual).must_equal(expected)
        end
      end

      describe "GroupedFileList#to_view" do
        describe "引数を取らず、mapで#to_viewを使用する場合" do
          it "戻り値は文字列型の二次元配列ある" do
            result = @test_repo.grouped_file_list.map(&:to_view)

            expected = result.all? do |grouped|
              grouped.all?(String)
            end

            _(true).must_equal(expected)
          end

          it "ディレクトリ名に色付けをしてディレクトリとファイル名の配列を返す" do
            expected = @test_repo.grouped_file_list.map(&:to_view)

            actual = @test_seeds.group_by(&:parent_dir).map do |dir, grouped|
              [Rainbow(dir).green] + grouped.map(&:basename)
            end

            _(actual).must_equal(expected)
          end
        end

        describe "引数にディレクトリ名を取り、filter_mapで#to_viewを使用する場合" do
          it "引数と同じディレクトリ名を色付けして、その中のファイル名と一緒に値を返す" do
            target_dir = "cli"
            expected = @test_repo.grouped_file_list.filter_map { |grouped| grouped.to_view(target_dir) }

            actual = @test_seeds.group_by(&:parent_dir).filter_map do |dir, grouped|
              [Rainbow(dir).green] + grouped.map(&:basename) if dir == target_dir
            end

            _(actual).must_equal(expected)
          end

          it "メモの中に存在しないディレクトリ名を受け取った場合は、空の配列を返す" do
            target_dir = "not_exist_dir"
            expected = @test_repo.grouped_file_list.filter_map { |grouped| grouped.to_view(target_dir) }

            _([]).must_equal(expected)
          end
        end
      end
    end

    describe "#walk_seed_hash" do
      describe "戻り値の型検査" do
        it "戻り値はHashである" do
          result = @test_repo.walk_seed_hash

          _(result).must_be_instance_of Hash
        end

        it "キーは文字列かnilとなる" do
          result = @test_repo.walk_seed_hash

          keys_type = result.keys.all? { |key| key.instance_of?(String) || key.nil? }

          _(true).must_equal keys_type
        end

        it "値はSeedかDirSeedの一次元配列となる" do
          result = @test_repo.walk_seed_hash

          values_type = result.values.all? do |seeds|
            seeds.all? do |seed|
              seed.instance_of?(Memo::Model::Seed) || seed.instance_of?(Memo::Model::DirSeed)
            end
          end

          _(true).must_equal values_type
        end
      end

      describe "戻り値の値検査" do
        it "キーがnilの値は、対象のディレクトリの最上位であることを示すDirSeedが一つだけ入っている一次元配列である" do
          test_walk_seed_hash = @test_repo.walk_seed_hash

          actual = test_walk_seed_hash[nil]

          # NOTE: actualは次のような一次元配列である。
          # parent_dirはnilであるようなDirSeedが一つだけ入っている
          # 例: [#<struct Memo::Model::DirSeed basename="memo", parent_dir=nil, dir="memo">]
          _(1).must_equal(actual.length)
          _(actual[0]).must_be_instance_of Memo::Model::DirSeed
          _(actual[0].parent_dir).must_be_nil
        end

        it "キーが対象のディレクトリの最上位であるときの値は、DirSeedかSeedの一次元配列であり、そのparent_dirかdirがディレクトリの最上位を示す文字列である" do
          test_walk_seed_hash = @test_repo.walk_seed_hash

          values = test_walk_seed_hash[@test_root_dirname]

          actual = values.all? do |seed|
            seed.parent_dir == @test_root_dirname
          end

          _(true).must_equal(actual)
        end
      end
    end

    describe '#grouped_file_list_hash' do
      describe '戻り値の型検査' do
        it "キーがディレクトリを示す文字列で、値がファイル名を示す文字列の配列となるHashを返す" do
          result = @test_repo.grouped_file_list_hash

          keys_type = result.keys.all?(String)
          values_type = result.values.all? do |filenames|
            filenames.all?(String)
          end

          _(result).must_be_instance_of Hash
          _(true).must_equal keys_type
          _(true).must_equal values_type
        end
      end

      describe '戻り値の値検査' do
        it "モックデータの値と同じであること" do
          actual = @test_repo.grouped_file_list_hash

          expected = @test_seeds.group_by(&:parent_dir).transform_values { |seeds| seeds.map(&:basename) }

          _(actual).must_equal(expected)
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
