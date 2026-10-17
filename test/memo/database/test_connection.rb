# frozen_string_literal: true

require_relative '../../helper'

class TestConnection < Minitest::Test
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
      Memo::Database::Connection.execute do |conn|
        expected_object = Sequel::SQLite::Database

        _(conn).must_be_instance_of(expected_object)
      end
    end
  end
end
