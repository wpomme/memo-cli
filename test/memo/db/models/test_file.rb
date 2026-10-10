# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::File') do
    describe('#new') do
      it('Fileモデルのインスタンスを作成できること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)
        actual_instance = Memo::DB::Models::File.new(db)

        _(actual_instance).must_be_instance_of(Memo::DB::Models::File)
      end
    end
  end
end
