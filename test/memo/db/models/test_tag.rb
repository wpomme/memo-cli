# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::Tag') do
    describe('#new') do
      it('Tagモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)

        Memo::DB::Models.tag(db)

        tag = Memo::DB::Models::Tag.new

        _(tag).must_be_instance_of(Memo::DB::Models::Tag)
        _(tag).must_be_kind_of(Sequel::Model)
      end
    end
  end
end
