# frozen_string_literal: true

require_relative '../../helper'

class TestService < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Loader::DirectoryLoader') do
    include Memo::Database
    include Memo::Loader::DirectoryLoader

    describe('Integration Test::DirectoryLoader') do
      it('#absolute_paths_sizeと#rel_paths_sizeが同じ値となること') do
        act1 = absolute_paths_size
        act2 = rel_paths_size

        _(act1).must_equal(act2)
      end
    end

    describe('#directory_tree') do
      it('値の中に"."が含まれること。"."は設定ディレクトリのカレントディレクトリを表す。') do
        actual = directory_tree.values.all? do |dir_node|
          dir_node.keys.include?('.')
        end

        _(actual).must_equal(true)
      end
    end

    describe('#absolute_paths') do
      it('configで設定されたディレクトリも含むこと') do
        test_target_dirs = Memo::Config.target_dirs

        actual = test_target_dirs.all? do |target_dir|
          absolute_paths.include?(target_dir)
        end

        _(actual).must_equal(true)
      end
    end

    describe('#rel_paths_hash') do
      it('キーが設定ファイルで定義されたディレクトリで、そのキーの中のディレクトリの一覧が値となる') do
        actual = rel_paths_hash.all? do |target_dir, dirs|
          FileTest.directory?(target_dir) && dirs.all? { |dir| FileTest.directory?(File.join(target_dir, dir)) }
        end

        _(actual).must_equal(true)
      end
    end
  end
end
