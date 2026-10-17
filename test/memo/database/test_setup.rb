# frozen_string_literal: true

require_relative '../../helper'

class TestSetup < Minitest::Test
  include MemoDBTestLifecycleHooks
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
      Memo::Database::DB.synchronize do |conn|
        expected_object = SQLite3::Database

        _(conn).must_be_instance_of(expected_object)
      end
    end
  end

  describe('#prepare') do
    it('テーブルが作成されること') do
      Memo::Database::Setup.prepare

      actual = Memo::Database::TABLE_NAMES.all? do |table_name|
        DB.table_exists?(table_name)
      end
      _(actual).must_equal(true)
    end
  end

  describe('#execute') do
    def setup
      @result = Memo::Database::Setup.execute
    end

    def teardown
      Memo::Database::Controller::FileTag.new.delete
      Memo::Database::Controller::Tag.new.delete
      Memo::Database::Controller::File.new.delete
      Memo::Database::Controller::Directory.new.delete
      Memo::Database::Controller::ConfigDirectory.new.delete
      super
    end

    # TODO: actualの回数が倍になって、テストが失敗する場合がある
    # おそらくDB接続の問題か、並行処理の問題
    it('挿入したデータの件数が、全てのタグの出現回数と同じになること') do
      each_array_size = @result.values.map(&:size)
      actual_size = each_array_size.inject(:+)

      expected_size = Memo::Loader::FileLoader.new.total_tag_size

      _(actual_size).must_equal(expected_size)
    end
  end
end
