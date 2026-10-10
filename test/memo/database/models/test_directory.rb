# frozen_string_literal: true

require_relative '../../../helper'

class TestSetUp < Minitest::Test
  describe('Models::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#directory') do
      it('Directoryモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        # Directoryクラスを動的に生成する
        # Memo::DB::Models.directory

        directory = Memo::Database::Models::Directory.new

        _(directory).must_be_instance_of(Memo::Database::Models::Directory)
        _(directory).must_be_kind_of(Sequel::Model)
      end

      describe('#create') do
        it('Directoryモデルを使って、データを一件挿入できること') do
          skip 'TODO'
          absolute_path = File.join(Dir.home, '/var')

          directory = Memo::Database::Models::Directory.new

          # 既にデータがあれば削除する
          # db[:directories]
          directory
            .where(absolute_path: absolute_path)
            .delete

          # Memo::DB::Models::Directory.create(absolute_path: absolute_path)
          directory.create(absolute_path: absolute_path)

          actual = directory
            .select(:absolute_path)
            .where(absolute_path: absolute_path)
            .all
            .all? do |row|
              row.values[:absolute_path] == absolute_path
            end

          _(actual).must_equal(true)
        end
      end

      describe('#validate') do
        it('絶対パスは一意であり、同じ値は挿入できないこと') do
          skip 'TODO'
        end
      end
    end
  end
end
