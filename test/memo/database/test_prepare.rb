# frozen_string_literal: true

require_relative '../../helper'

class TestPrepare < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('#execute') do
    # it('本番環境と接続できること') do
    #   prepare = Memo::DB::Prepare.execute
    #
    #   expected_object = Sequel::SQLite::Database
    #
    #   _(prepare).must_be_instance_of(expected_object)
    # end

    it('テスト環境と接続できること。指定したDBファイルがなければ作成する') do
      skip 'TODO'
      Memo::Database::Prepare.execute(database_path: @database_path) do |conn|
        expected_object = Sequel::SQLite::Database

        _(conn).must_be_instance_of(expected_object)
      end
    end

    it('dbがブロックを受け取った場合の動作') do
      skip 'TODO'
    end

    it('dbがブロックを受け取らなかった場合の動作') do
      skip 'TODO'
    end
  end
end
