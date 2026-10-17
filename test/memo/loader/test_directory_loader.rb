# frozen_string_literal: true

require_relative '../../helper'

class TestService < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('DB::Service') do
    include Memo::Database
    include Memo::Loader::DirectoryLoader

    describe('#database_paths') do
      it('一次元配列を返し、その値はディレクトリであること') do
        actual = absolute_paths.all? do |path|
          FileTest.directory?(path)
        end

        _(actual).must_equal(true)
      end

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

    describe('#rel_paths_size') do
      it('正の整数を返すこと') do
        actual = rel_paths_size

        _(actual.positive?).must_equal(true)
      end
    end
  end
end
