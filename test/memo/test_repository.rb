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

        _(expected).must_equal(true)
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
        skip "TODO"
      end
    end

    describe '#dir_set' do
      it "モックデータと実際のdir_setが同じであること" do
        expected = @test_repo.dir_set
        actual = Memo::MockSeed::TEST_MEMO_DATA_SEED.map { |seed_hash| seed_hash[:dir] }.uniq.to_set

        _(expected).must_equal(actual)
      end
    end

    describe '#dir_seeds' do
      it '戻り値はDirSeedの一次元配列となる' do
        expected = @test_repo.dir_seeds.all?(Memo::Model::DirSeed)
        _(expected).must_equal(true)
      end

      it 'basenameがディレクトリのトップのとき、parent_dirはnilとなる' do
        root_dir_seed = @test_repo.dir_seeds.find { |seed| seed.basename == File.basename(@test_memo_dir) }
        _(root_dir_seed.parent_dir).must_be_nil
      end

      it 'ディレクトリのトップの直下にあるディレクトリは、parent_dirがルートディレクトリになる' do
        target_dir = 'cli'
        target_dir_seed = @test_repo.dir_seeds.find { |seed| seed.dir == target_dir }
        _(target_dir_seed.parent_dir).must_equal(File.basename(@test_memo_dir))
      end
    end

    describe '#find' do
      describe '戻り値の型検査' do
        describe "検索文字列と一致するファイル名が見つかった場合は、Seedの一次元配列を返す" do
          it "ファイル名が一件見つかった場合" do
            word = 'diff'
            ret = @test_repo.find(word)
            expected = ret.all?(Memo::Model::Seed)

            _(expected).must_equal(true)
          end

          it "ファイル名が複数件見つかった場合" do
            word = 'mise'
            ret = @test_repo.find(word)
            expected = ret.all?(Memo::Model::Seed)

            _(expected).must_equal(true)
          end
        end

        describe "検索文字列と一致するファイル名が見つからなかった場合は、空の配列を返す" do
          it "メモの中に存在しない検索文字列が入力された場合" do
            word = 'invalid_word'
            expected = @test_repo.find(word)

            _(expected).must_equal([])
          end
        end
      end

      describe "戻り値の値検査" do
        describe "検索文字列と一致するファイル名が見つかった場合は、そのSeedの一次元配列を返す" do
          it "ファイル名が一件見つかった場合" do
            word = 'diff'
            expected = @test_repo.find(word)
            actual = @test_seeds.filter { |seed| seed.filename == word }

            _(expected).must_equal(actual)
          end

          it "ファイル名が複数件見つかった場合" do
            word = 'mise'
            expected = @test_repo.find(word)
            actual = @test_seeds.filter { |seed| seed.filename == word }

            _(expected).must_equal(actual)
          end
        end
      end
    end

    describe '#grouped_file_list' do
      describe '戻り値の型検査' do
        it "GroupedFileListの一次元配列を返す" do
          ret = @test_repo.grouped_file_list
          expected = ret.all?(Memo::Model::GroupedFileList)

          _(expected).must_equal(true)
        end
      end

      describe '戻り値の値検査' do
        it "モックデータの値と同じであること" do
          expected = @test_repo.grouped_file_list

          actual = @test_seeds.group_by(&:dir).map do |dir, seed|
            Memo::Model::GroupedFileList.new(
              dir: dir,
              filenames: seed.map(&:filename)
            )
          end

          _(expected).must_equal(actual)
        end
      end

      describe "GroupedFileList#to_view" do
        describe "引数を取らず、mapで#to_viewを使用する場合" do
          it "戻り値は文字列型の二次元配列ある" do
            result = @test_repo.grouped_file_list.map(&:to_view)

            expected = result.all? do |grouped|
              grouped.all?(String)
            end

            _(expected).must_equal(true)
          end

          it "ディレクトリ名に色付けをしてディレクトリとファイル名の配列を返す" do
            expected = @test_repo.grouped_file_list.map(&:to_view)

            actual = @test_seeds.group_by(&:dir).map do |dir, grouped|
              [Rainbow(dir).green] + grouped.map(&:filename)
            end

            _(expected).must_equal(actual)
          end
        end

        describe "引数にディレクトリ名を取り、filter_mapで#to_viewを使用する場合" do
          it "引数と同じディレクトリ名を色付けして、その中のファイル名と一緒に値を返す" do
            target_dir = "cli"
            expected = @test_repo.grouped_file_list.filter_map { |grouped| grouped.to_view(target_dir) }

            actual = @test_seeds.group_by(&:dir).filter_map do |dir, grouped|
              [Rainbow(dir).green] + grouped.map(&:filename) if dir == target_dir
            end

            _(expected).must_equal(actual)
          end

          it "メモの中に存在しないディレクトリ名を受け取った場合は、空の配列を返す" do
            target_dir = "not_exist_dir"
            expected = @test_repo.grouped_file_list.filter_map { |grouped| grouped.to_view(target_dir) }

            _(expected).must_equal([])
          end
        end
      end
    end

    describe '#search_all' do
      describe '戻り値の型検査' do
        it "検索結果は二重配列で要素はMemo::Model::SearchLineである" do
          search_word = 'diff'
          result = @test_repo.search_all(search_word)

          expected = result.all? do |memo|
            memo.all?(Memo::Model::SearchLine)
          end

          _(expected).must_equal(true)
        end

        it "検索結果が空の場合は、空の二重配列を返す" do
          search_word = 'hikkakaranasounakotoba'
          result = @test_repo.search_all(search_word)

          expected = result.all? do |memo|
            memo.all?(&:empty?)
          end

          _(expected).must_equal(true)
        end
      end

      describe '戻り値の値検査' do
        it "モックデータから作成した検索結果と要素が同じである" do
          search_word = 'diff'
          expected = @test_repo.search_all(search_word)

          actual = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
            rel_path = File.join(seed[:dir], "#{seed[:filename]}.md")
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
