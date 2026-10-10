# frozen_string_literal: true

require_relative '../../helper'

class TestSetUp < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('#execute') do
    it('指定したパスを引数に入れると、そのパスに該当のテーブルを作成する') do
      skip 'TODO'
      # DBを作成する
      Memo::DB::SetUp.execute

      # DBが作成されたかどうかを検証するためにDBへの接続を図る
      Memo::DB::CONNECTION.transaction do |db|
        actual = Memo::DB::TABLE_NAMES.all? do |table_name|
          db[table_name].table_exists?
          _(actual).must_equal(true)
        end
      end
    end
  end
end
