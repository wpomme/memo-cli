# frozen_string_literal: true

require_relative '../../helper'

class TestService < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Loader::DirectoryLoader') do
    def setup
      super
      @directory_loader = Memo::Loader::DirectoryLoader.new
    end

    describe('Integration Test::DirectoryLoader') do
      it('絶対パスと相対パスの合計が同じ値となること') do
        absolute_path_size = @directory_loader.absolute_paths.size
        relative_path_hash = @directory_loader.relative_path_hash

        relative_path_size = relative_path_hash.keys.map do |key|
          relative_path_hash[key].size
        end
          .inject(:+)

        _(absolute_path_size).must_equal(relative_path_size)
      end
    end

    describe('#rel_path_hash') do
      it('値の中に空文字を含むこと') do
        actual = @directory_loader.relative_path_hash.values.all? do |dirs|
          dirs.include?('')
        end

        _(actual).must_equal(true)
      end
    end

    describe('#directory_tree') do
      it('値の中に"."が含まれること。"."は設定ディレクトリのカレントディレクトリを表す。') do
        actual = @directory_loader.directory_tree.values.all? do |dir_node|
          dir_node.keys.include?('.')
        end

        _(actual).must_equal(true)
      end
    end

    describe('#absolute_paths') do
      it('configで設定されたディレクトリも含むこと') do
        test_target_dirs = Memo::Config.target_dirs

        actual = test_target_dirs.all? do |target_dir|
          @directory_loader.absolute_paths.include?(target_dir)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
