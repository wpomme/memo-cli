# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::Directory') do
    describe('#new') do
      it('Directoryモデルのインスタンスを作成できること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)
        actual_instance = Memo::DB::Models::Directory.new(db)

        _(actual_instance).must_be_instance_of(Memo::DB::Models::Directory)
        # _(actual_instance).must_be_kind_of(Sequel::Model)
      end

      # it('新しくデータをテーブルに保存できること') do
      #   database_path = 'test_memo.db'
      #   db = Memo::DB::Connection.execute(database_path)
      #   directory = Memo::DB::Models::Directory.new(db)
      #   absolute_path = File.join(Dir.home, '/var')
      #
      #   ret = directory.set(absolute_path: absolute_path)
      #
      #   _(ret).must_equal('')
      # end
    end
  end
end
