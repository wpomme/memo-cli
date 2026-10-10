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
      Memo::DB::Prepare.execute do |prepare|
        expected_object = Sequel::SQLite::Database

        _(prepare).must_be_instance_of(expected_object)
      end
    end
  end
end
