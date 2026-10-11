# frozen_string_literal: true

require_relative '../../helper'

class TestSetup < Minitest::Test
  include MemoDBTestLifecycleHooks
  include Memo::Database

  describe('#execute') do
    it('必要なテーブルを作成する。既にテーブルが存在すれば、削除して作成し直す') do
      # DBを作成する
      Memo::Database::Setup.execute

      actual = Memo::Database::TABLE_NAMES.all? do |table_name|
        DB.table_exists?(table_name)
      end
      _(actual).must_equal(true)
    end
  end
end
