# frozen_string_literal: true

require_relative '../../helper'

class TestSetup < Minitest::Test
  include MemoDBTestLifecycleHooks
  include Memo::Database

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
      Memo::Database::DB[:files_tags].delete
      Memo::Database::DB[:tags].delete
      Memo::Database::DB[:files].delete
      Memo::Database::DB[:directories].delete
      Memo::Database::DB[:config_directories].delete
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
