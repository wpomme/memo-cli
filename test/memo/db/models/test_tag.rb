# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::Tag') do
    describe('#new') do
      it('Tagモデルのインスタンスを作成できること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)
        actual_instance = Memo::DB::Models::Tag.new(db)

        _(actual_instance).must_be_instance_of(Memo::DB::Models::Tag)
      end
    end
  end
end
