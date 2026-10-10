# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::File') do
    describe('#new') do
      it('Fileモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        database_path = 'test_memo.db'
        Memo::DB::Connection.execute(database_path) do |db|
          Memo::DB::Models.file(db)

          file = Memo::DB::Models::File.new

          _(file).must_be_instance_of(Memo::DB::Models::File)
          _(file).must_be_kind_of(Sequel::Model)
        end
      end
    end
  end
end
