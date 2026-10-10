# frozen_string_literal: true

class TestConnection < Minitest::Test
  describe('#execute') do
    it('本番環境と接続できること') do
      connection = Memo::DB::Connection.execute

      expected_object = Sequel::SQLite::Database

      _(connection).must_be_instance_of(expected_object)
    end

    it('テスト環境と接続できること。指定したDBファイルがなければ作成する') do
      database_path = 'test_memo.db'
      connection = Memo::DB::Connection.execute(database_path)

      expected_object = Sequel::SQLite::Database

      _(connection).must_be_instance_of(expected_object)
    end
  end
end
