# frozen_string_literal: true

require_relative '../../helper'

class TestService < Minitest::Test
  describe('Loader::DirectoryLoader') do
    include MemoLifecycleHooks

    def setup
      super
      @directory_loader = Memo::DirectoryLoader.new(target_dirs: @test_target_dirs)
    end

    describe('#absolute_paths') do
      it('configで設定されたディレクトリも含むこと') do
        actual = @test_target_dirs.all? do |target_dir|
          @directory_loader.absolute_paths.include?(target_dir << '/')
        end

        _(actual).must_equal(true)
      end
    end

    describe('#directory_seeds_hash') do
      it('モックデータから作成したハッシュと同じ値となること') do
        actual = @directory_loader.directory_seeds_hash

        expected = @test_target_dirs.to_h do |target_dir|
          [target_dir, [''].concat(Dir.glob('**/*/', base: target_dir))]
        end

        _(actual).must_equal(expected)
      end
    end

    describe('#directory_seeds') do
      it('relative_pathについて、モックデータと同じであること。また、relative_pathはディレクトリのトップを示す空文字の場合があること') do
        ret = @directory_loader.directory_seeds

        act_set = ret.map.to_set do |dir_seed|
          dir_seed[:relative_path]
        end

        exp = @test_target_dirs.map do |target_dir|
          Dir.glob('**/*/', base: target_dir)
        end

        exp_set = exp.flatten.to_set.add('')

        _(act_set - exp_set).must_equal(Set.new)
      end

      it('absolute_pathについて、モックデータと同じであること。また、対象ディレクトリにスラッシュを付けたものも含まれること') do
        ret = @directory_loader.directory_seeds

        act_set = ret.map.to_set do |dir_seed|
          dir_seed[:absolute_path]
        end

        exp = @test_target_dirs.map do |target_dir|
          Dir.glob('**/*/', base: target_dir).map do |rel_path|
            File.join(target_dir, rel_path)
          end
        end

        exp_set = exp.flatten.to_set

        @test_target_dirs.each do |test_target_dir|
          exp_set.add("#{test_target_dir}/")
        end

        _(act_set - exp_set).must_equal(Set.new)
      end

      it('target_dirについて、いずれかの対象ディレクトリと同じであること。') do
        ret = @directory_loader.directory_seeds

        act_set = ret.map.to_set do |dir_seed|
          dir_seed[:target_dir]
        end

        exp_set = @test_target_dirs.to_set

        _(act_set - exp_set).must_equal(Set.new)
      end
    end
  end
end
