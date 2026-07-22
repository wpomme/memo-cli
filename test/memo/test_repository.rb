# frozen_string_literal: true

require_relative "../test_helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      it '@seedsはMemo::Model::SeedのArrayである' do
        repo = Memo::Repository.new(@memo_dir)
        seeds = repo.instance_variable_get(:@seeds)

        assert_instance_of Array, seeds
        seeds.each do |seed|
          assert_instance_of Memo::Model::Seed, seed
        end
      end

      it '@seeds.full_pathはREADME(.md) を含まない' do
        repo = Memo::Repository.new(@memo_dir)
        seeds = repo.instance_variable_get(:@seeds)
        full_path = seeds.map(&:full_path)

        refute_includes full_path, "README"
        refute_includes full_path, "README.md"
      end

      # これが成り立たないとmemo readが出来ない
      # ただ、どちらかといえば、memoフォルダの設定ミスのために生じる不具合のような
      it '@seeds:full_path は絶対パスである' do
        repo = Memo::Repository.new(@memo_dir)
        seeds = repo.instance_variable_get(:@seeds)
        full_paths = seeds.map(&:full_path)

        full_paths.each do |full_path|
          assert File.absolute_path?(full_path)
        end
      end
    end

    describe '#find' do
      it "memoの中に存在するファイルが見つかった場合は、そのファイルのSeedの配列を返す" do
        word = 'find'
        expected = Memo::Repository.new(@memo_dir).find(word)
        actual = Memo::Model::Seed.new(full_path: File.join(@memo_dir, "cli", "find.md"), filename: "find", dir: "cli")

        assert_equal actual, expected
      end

      it "memoの中に存在しないwordが入力された場合は、nilを返す" do
        word = 'invalid_word'
        expected = Memo::Repository.new(@memo_dir).find(word)

        assert_nil expected
      end

      it "wordがnilの場合も、nilを返す" do
        word = nil
        expected = Memo::Repository.new(@memo_dir).find(word)

        assert_nil expected
      end
    end

    describe '#read' do
      it "seedが存在すれば、そのファイルを全文表示する。、" do
        expected_seed = @test_repository_seeds.find { |seed| seed.filename == "find" }
        Memo::Repository.new(@memo_dir)
        expected = Memo::Repository.read(expected_seed)

        actual = MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT.split("\n")

        assert_equal actual, expected
      end

      it "nilが与えられたら、そのままnilを返す" do
        Memo::Repository.new(@memo_dir)
        expected = Memo::Repository.read(nil)

        assert_nil expected
      end
    end

    describe '#files_grouped_by_dir' do
      it "ディレクトリの文字列をキーで、値がそのディレクトリに所属するファイル名の配列であるHashを返す" do
        expected = Memo::Repository.new(@memo_dir).files_grouped_by_dir

        _(expected).must_equal(@test_repository_grouped_files)
      end
    end

    describe '#grouped_file_list' do
      it "Structを返す" do
        expected = Memo::Repository.new(@memo_dir).grouped_file_list

        actual = @test_repository_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename).sort
          )
        end

        _(actual).must_equal(expected)
      end
    end
  end
end
