# frozen_string_literal: true

require_relative '../helper'

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      describe '#load, @seeds' do
        it '@seedsの配列の要素はMemo::Model::Seedである' do
          seeds = @test_repo.instance_variable_get(:@seeds)
          expected = seeds.all?(Memo::Model::Seed)

          _(true).must_equal(expected)
        end

        it '@seeds.full_path は絶対パスである' do
          seeds = @test_repo.instance_variable_get(:@seeds)
          full_paths = seeds.map(&:full_path)

          actual = full_paths.all? do |full_path|
            File.absolute_path?(full_path)
          end

          _(actual).must_equal(true)
        end
      end

      describe '@dir_seed, #load_dirs' do
        # File#dirnae: https://docs.ruby-lang.org/ja/latest/method/File/s/dirname.html
        # File#basename: https://docs.ruby-lang.org/ja/latest/method/File/s/basename.html
        describe 'dir_seedに入る値を明確にするために、File.dirnameとFile.basenameの動作を説明するためのテストを作成する' do
          it 'File.dirname("foo")は"."になる' do
            expected = File.dirname('foo')
            actual = '.'
            _(actual).must_equal(expected)
          end

          it 'File.dirname("/foo/bar/baz")は"/foo/bar"になる' do
            expected = File.dirname('/foo/bar/baz')
            actual = '/foo/bar'
            _(actual).must_equal(expected)
          end

          it 'File.basename("/foo/bar/baz")は"bar"になる。"/foo/bar/baz/"でも同様である。' do
            expected1 = File.basename('/foo/bar/baz')
            expected2 = File.basename('/foo/bar/baz/')

            actual = 'baz'

            _(actual).must_equal(expected1)
            _(actual).must_equal(expected2)
          end
        end

        it 'target_dirの方が"cli"のようにディレクトリの第一階層を示すなら、parent_dirは第二引数と同じになる' do
          skip 'TODO'
          target_dir = 'cli'
          target_dir_seed = Memo::Model::DirSeed.new(target_dir, @test_root_dirname)
          _(target_dir_seed.parent_dir).must_equal(@test_root_dirname)
        end

        it 'target_dirの方が"aaa/bbb/ccc"のようにディレクトリの第一階層以外を示すなら、parent_dirはaaa/bbbとなる' do
          skip 'TODO'
          target_dir = 'aaa/bbb/ccc'
          target_dir_seed = Memo::Model::DirSeed.new(target_dir, @test_root_dirname)

          actual = 'aaa/bbb'

          _(actual).must_equal(target_dir_seed.parent_dir)
        end
      end
    end

    describe '#dir_set' do
      it 'dir_setの中に対象の最上位のディレクトリが含まれていること' do
        dir_set = @test_repo.dir_set

        @test_root_dirnames.each do |dir|
          _(dir_set.include?(dir)).must_equal(true)
        end
      end
      it 'モックデータと実際のdir_setが同じであること' do
        actual = @test_repo.dir_set

        test_dir_seeds = @test_repo.instance_variable_get(:@dir_seeds)
        tmp_dirs = test_dir_seeds
          .map(&:rel_path)
          .map { |dir| dir.rstrip('/') }
        expected = Set.new(tmp_dirs).merge(@test_root_dirnames)

        _(actual).must_equal(expected)
      end
    end

    describe '#find' do
      describe '戻り値の型検査' do
        describe '検索文字列と一致するファイル名が見つかった場合は、Seedの一次元配列を返す' do
          it 'ファイル名が一件見つかった場合' do
            word = @fixed_search_word
            ret = @test_repo.find(word)
            expected = ret.all?(Memo::Model::Seed)

            _(true).must_equal(expected)
          end

          it 'ファイル名が複数件見つかった場合' do
            word = @fixed_duplicated_filename
            ret = @test_repo.find(word)
            expected = ret.all?(Memo::Model::Seed)

            _(true).must_equal(expected)
          end
        end

        describe '検索文字列と一致するファイル名が見つからなかった場合は、空の配列を返す' do
          it 'メモの中に存在しない検索文字列が入力された場合' do
            word = 'invalid_word'
            expected = @test_repo.find(word)

            _([]).must_equal(expected)
          end
        end
      end

      describe '戻り値の値検査' do
        describe '検索文字列と一致するファイル名が見つかった場合は、そのSeedの一次元配列を返す' do
          it 'ファイル名が一件見つかった場合' do
            word = @fixed_search_word
            expected = @test_repo.find(word)
            actual = @test_seeds.filter { |seed| seed.basename == word }

            _(actual).must_equal(expected)
          end

          it 'ファイル名が複数件見つかった場合' do
            word = @fixed_duplicated_filename
            expected = @test_repo.find(word)
            actual = @test_seeds.filter { |seed| seed.basename == word }

            _(actual).must_equal(expected)
          end
        end
      end
    end

    describe '#empty_tags_file_list' do
      it '加工したモックデータと戻り値が同じであること' do
        actual = @test_repo.empty_tags_file_list

        expected = @test_seeds.filter { |seed| seed['tags'].empty? }

        _(actual).must_equal(expected)
      end
    end

    describe '#grouped_ls' do
      describe '戻り値の型検査' do
        it '戻り値はHashである' do
          result = @test_repo.grouped_ls

          _(result).must_be_instance_of Hash
        end

        it 'キーは文字列となる' do
          result = @test_repo.grouped_ls

          actual = result.keys.all?(String)

          _(actual).must_equal true
        end

        it '値はSeedの一次元配列となる' do
          result = @test_repo.grouped_ls

          actual = result.values.all? do |seeds|
            seeds.all?(Memo::Model::Seed)
          end

          _(actual).must_equal true
        end
      end

      describe '戻り値の値検査' do
        it 'キーが対象のディレクトリの最上位であるとき、その値のparent_dirは全てキーと同じ値になり、その値はディレクトリの最上位を表す文字列となる' do
          grouped_ls_hash = @test_repo.grouped_ls

          values = @test_root_dirnames.map do |dir|
            grouped_ls_hash[dir]
          end.flatten

          actual = values.all? do |seed|
            @test_root_dirnames.include?(seed.parent_dir)
          end

          _(true).must_equal(actual)
        end
      end
    end

    describe '#tag_list' do
      describe '戻り値の型検査' do
        it '文字列型の一次元配列を返す' do
          tag_list = @test_repo.tag_list
          actual = tag_list.all?(String)

          _(actual).must_equal(true)
        end
      end

      describe '戻り値の値検査' do
        it 'モックデータから作成したタグの一覧と、Repository#tag_listの値が同じであること' do
          actual = @test_repo.tag_list

          expected = @test_seeds.map(&:tags).flatten.uniq

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#tag_seeds_hash' do
      describe '戻り値の型検査' do
        it 'キーが文字列で、値が要素がSeedの一次元配列となるハッシュを返す' do
          tag_seeds_hash = @test_repo.tag_seeds_hash

          _(tag_seeds_hash).must_be_instance_of(Hash)

          keys_type = tag_seeds_hash.keys.all?(String)
          values_type = tag_seeds_hash.values.all? do |value|
            value.all?(Memo::Model::Seed)
          end

          _(keys_type).must_equal(true)
          _(values_type).must_equal(true)
        end
      end

      describe '戻り値の値検査' do
        it 'モックデータから作成したタグの一覧と、Repository#tag_seeds_hashの値が同じであること' do
          actual = @test_repo.tag_seeds_hash

          expected = @test_repo.tag_list.to_h do |tag|
            [
              tag,
              @test_seeds.filter do |seed|
                seed['tags'].include?(tag)
              end
            ]
          end

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#search_all' do
      describe '戻り値の型検査' do
        it '検索結果は二重配列で要素はMemo::Model::SearchLineである' do
          search_word = @fixed_search_word
          result = @test_repo.search_all(search_word)

          expected = result.all? do |memo|
            memo.all?(Memo::Model::SearchLine)
          end

          _(true).must_equal(expected)
        end

        it '検索結果が空の場合は、空の二重配列を返す' do
          search_word = 'hikkakaranasounakotoba'
          result = @test_repo.search_all(search_word)

          expected = result.all? do |memo|
            memo.all?(&:empty?)
          end

          _(true).must_equal(expected)
        end
      end

      describe '戻り値の値検査' do
        it 'モックデータから作成した検索結果と要素が同じである' do
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
