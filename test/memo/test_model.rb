# frozen_string_literal: true

require_relative "../helper"

class TestModel < Minitest::Test
  describe 'Model' do
    include MemoTestLifecycleHooks

    describe '#DirSeed' do
      # File#dirnae: https://docs.ruby-lang.org/ja/latest/method/File/s/dirname.html
      # File#basename: https://docs.ruby-lang.org/ja/latest/method/File/s/basename.html
      describe 'DirSeed.newの動作を明確にするために、File.dirnameとFile.basenameの動作を説明するためのテストを作成する' do
        it 'File.dirname("foo")は"."になる' do
          expected = File.dirname("foo")
          actual = "."
          _(actual).must_equal(expected)
        end

        it 'File.dirname("/foo/bar/baz")は"/foo/bar"になる' do
          expected = File.dirname("/foo/bar/baz")
          actual = "/foo/bar"
          _(actual).must_equal(expected)
        end

        it 'File.basename("/foo/bar/baz")は"bar"になる。"/foo/bar/baz/"でも同様である。' do
          expected1 = File.basename("/foo/bar/baz")
          expected2 = File.basename("/foo/bar/baz/")

          actual = "baz"

          _(actual).must_equal(expected1)
          _(actual).must_equal(expected2)
        end
      end

      it 'DirSeed.newに渡す二つの引数が同じディレクトリのとき、そのDirSeedはルートディレクトリとみなし、parent_dirをnilにする' do
        target_dir_seed = Memo::Model::DirSeed.new(@test_root_dirname, @test_root_dirname)
        _(target_dir_seed.parent_dir).must_be_nil
      end

      it 'DirSeed.newに渡す引数のうち、target_dirの方が"cli"のようにディレクトリの第一階層を示すなら、parent_dirは第二引数と同じになる' do
        target_dir = 'cli'
        target_dir_seed = Memo::Model::DirSeed.new(target_dir, @test_root_dirname)
        _(target_dir_seed.parent_dir).must_equal(@test_root_dirname)
      end

      it 'DirSeed.newに渡す引数のうち、target_dirの方が"aaa/bbb/ccc"のようにディレクトリの第一階層以外を示すなら、parent_dirはaaa/bbbとなる' do
        target_dir = 'aaa/bbb/ccc'
        target_dir_seed = Memo::Model::DirSeed.new(target_dir, @test_root_dirname)

        actual = "aaa/bbb"

        _(actual).must_equal(target_dir_seed.parent_dir)
      end
    end
  end
end
