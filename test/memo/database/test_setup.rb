# frozen_string_literal: true

require_relative '../../helper'

class TestSetup < Minitest::Test
  include MemoDBTestLifecycleHooks
  include Memo::Database

  describe('#execute') do
    def teardown
      Memo::Database::DB[:files_tags].delete
      Memo::Database::DB[:tags].delete
      Memo::Database::DB[:files].delete
      Memo::Database::DB[:directories].delete
      super
    end
    it('必要なテーブルを作成して、各々のデータを挿入する。') do
      # 各々のテーブルを作成する
      result = Memo::Database::Setup.execute

      actual_table = Memo::Database::TABLE_NAMES.all? do |table_name|
        DB.table_exists?(table_name)
      end
      _(actual_table).must_equal(true)

      actual_type = result.all? do |file_tag_id, tag_ids|
        file_tag_id.instance_of?(Integer) && tag_ids.all?(Integer)
      end

      # resultの配列の総数と、全てのタグの出現回数は同じになる
      # NOTE: 計算に時間がかかっており、二行に分けて計算している
      each_array_size = result.values.map(&:size)
      actual_size = each_array_size.inject(:+)

      expected_size = Memo::Database::FileLoader.new.all_tag_count_of_appearance

      _(actual_type).must_equal(true)
      _(actual_size).must_equal(expected_size)
    end
  end
end
