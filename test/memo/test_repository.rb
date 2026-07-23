# frozen_string_literal: true

require_relative "../test_helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      it '@seedsはMemo::Model::SeedのArrayである' do
        seeds = @repo.instance_variable_get(:@seeds)

        assert_instance_of Array, seeds
        seeds.each do |seed|
          assert_instance_of Memo::Model::Seed, seed
        end
      end

      it '@seeds.full_pathはREADME(.md) を含まない' do
        seeds = @repo.instance_variable_get(:@seeds)
        full_path = seeds.map(&:full_path)

        refute_includes full_path, "README"
        refute_includes full_path, "README.md"
      end

      # これが成り立たないとmemo readが出来ない
      # ただ、どちらかといえば、memoフォルダの設定ミスのために生じる不具合のような
      it '@seeds:full_path は絶対パスである' do
        seeds = @repo.instance_variable_get(:@seeds)
        full_paths = seeds.map(&:full_path)

        full_paths.each do |full_path|
          assert File.absolute_path?(full_path)
        end
      end
    end

    describe '#find' do
      it "memoの中に存在するファイルが見つかった場合は、そのファイルのSeedの配列を返す" do
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
        expected_seed = @test_seeds.find { |seed| seed.filename == "push" }
        expected = @repo.read(expected_seed)

        actual = Memo::MockSeed::TEST_PUSH_FILE_CONTENT

        assert_equal expected, actual.split("\n") << ""
      end

      it "nilが与えられたら、そのままnilを返す" do
        expected = @repo.read(nil)

        assert_nil expected
      end
    end
  end
end
