# frozen_string_literal: true

require_relative '../../helper'

class TestSetUp < Minitest::Test
  include MemoDBTestLifecycleHooks
  include Memo::Database

  describe('#execute') do
    it('指定したパスを引数に入れると、そのパスに該当のテーブルを作成する') do
      # DBを作成する
      Memo::Database::SetUp.execute

      actual = Memo::Database::TABLE_NAMES.all? do |table_name|
        DB.table_exists?(table_name)
      end
      _(actual).must_equal(true)
    end
  end
end
