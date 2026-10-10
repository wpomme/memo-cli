# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('#execute') do
    it('指定したパスを引数に入れると、そのパスに該当のテーブルを作成する') do
      database_path = 'test_memo.db'

      # DBを作成する
      Memo::DB::SetUp.execute(database_path)

      # DBが作成されたかどうかを検証するためにDBへの接続を図る
      db = Memo::DB::Connection.execute(database_path)

      actual = Memo::DB::TABLE_NAMES.all? do |table_name|
        db.table_exists?(table_name)
      end

      _(actual).must_equal(true)
    end
  end
end
