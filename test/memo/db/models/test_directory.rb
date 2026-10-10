# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::Directory') do
    describe('#directory') do
      it('Directoryモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        database_path = 'test_memo.db'
        Memo::DB::Connection.execute(database_path) do |db|
          # Directoryクラスを動的に生成する
          Memo::DB::Models.directory(db)

          directory = Memo::DB::Models::Directory.new

          _(directory).must_be_instance_of(Memo::DB::Models::Directory)
          _(directory).must_be_kind_of(Sequel::Model)
        end
      end

      describe('#create') do
        it('Directoryモデルを使って、データを一件挿入できること') do
          database_path = 'test_memo.db'
          absolute_path = File.join(Dir.home, '/var')

          Memo::DB::Connection.execute(database_path) do |db|
            directory = Memo::DB::Models.directory(db)

            # 既にデータがあれば削除する
            # db[:directories]
            directory
              .where(absolute_path: absolute_path)
              .delete

            # Memo::DB::Models::Directory.create(absolute_path: absolute_path)
            directory.create(absolute_path: absolute_path)
          end

          db = Memo::DB::Connection.execute(database_path)
          directory = Memo::DB::Models.directory(db)

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
