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
          [target_dir, ['./'].concat(Dir.glob('**/*/', base: target_dir))]
        end

        _(actual).must_equal(expected)
      end
    end
  end
end
