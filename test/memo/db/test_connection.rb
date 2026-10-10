# frozen_string_literal: true

class TestConnection < Minitest::Test
  describe('#execute') do
    it('executeを呼び出しても正常に実行できる') do
      connection = Memo::DB::Connection.execute

      expected_object = Sequel::SQLite::Database

      _(connection).must_be_instance_of(expected_object)
    end

    it('指定したDBのファイルがなければ、作成して、SQLite3と接続できるようにする') do
      database_path = 'test_memo.db'
      connection = Memo::DB::Connection.execute(database_path)

      expected_object = Sequel::SQLite::Database

      _(connection).must_be_instance_of(expected_object)
    end
  end
end
