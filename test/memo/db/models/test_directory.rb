# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::Directory') do
    describe('#directory') do
      it('Directoryモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)

        # Directoryクラスを動的に生成する
        Memo::DB::Models.directory(db)

        directory = Memo::DB::Models::Directory.new

        _(directory).must_be_instance_of(Memo::DB::Models::Directory)
        _(directory).must_be_kind_of(Sequel::Model)
      end

      describe('#create') do
        it('Directoryモデルを使って、データを一件挿入できること') do
          skip 'TODO: controllerのコードを参考にしてテストコードを作成する'
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
