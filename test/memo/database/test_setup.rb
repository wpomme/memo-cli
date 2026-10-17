# frozen_string_literal: true

require_relative '../../helper'

class TestSetup < Minitest::Test
  # include MemoDBTestLifecycleHooks
  include Memo::Database

  describe('Database::DB') do
    # it('本番環境と接続できること') do
    #   prepare = Memo::DB::Prepare.execute
    #
    #   expected_object = Sequel::SQLite::Database
    #
    #   _(prepare).must_be_instance_of(expected_object)
    # end

    it('テスト環境と接続できること。指定したDBファイルがなければ作成する') do
      skip 'TODO'
      @db.synchronize do |conn|
        expected_object = SQLite3::Database

        _(conn).must_be_instance_of(expected_object)
      end
    end
  end

  describe('#prepare') do
    def setup
      super
      test_database_filename = 'memo_test.db'
      @test_database_path = Memo::Config.target_database(database_filename: test_database_filename)
      @db = Memo::Database.db(database_path: @test_database_path)
      Memo::Database::Setup.new(@db).prepare
    end

    it('テーブルが作成されること') do
      actual = Memo::Database::TABLE_NAMES.all? do |table_name|
        @db.table_exists?(table_name)
      end
      _(actual).must_equal(true)
    end
  end

  describe('#execute') do
    def setup
      super
      test_database_filename = 'memo_test.db'
      @test_database_path = Memo::Config.target_database(database_filename: test_database_filename)
      @db = Memo::Database.db(database_path: @test_database_path)
    end

    it('挿入したデータの件数が、全てのタグの出現回数と同じになること') do
      Memo::Database::Setup.new(@db).execute

      actual = Memo::Database::Controller::FileTag.new.count

      expected = Memo::Loader::FileLoader.new.total_tag_size

      _(actual).must_equal(expected)
    end
  end
end
