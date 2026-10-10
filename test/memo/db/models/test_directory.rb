# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Models::Directory') do
    describe('#directory') do
      it('Directoryモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)

        # Directoryクラスを動的に生成する
        Memo::DB::Models.directory(db)

        directory = Memo::DB::Models::Directory.new

        _(directory).must_be_instance_of(Memo::DB::Models::Directory)
        _(directory).must_be_kind_of(Sequel::Model)
      end

      # it('新しくデータをテーブルに保存できること') do
      #   database_path = 'test_memo.db'
      #   db = Memo::DB::Connection.execute(database_path)
      #
      #   Memo::DB::Models.directory(db)
      #
      #   directory = Memo::DB::Models::Directory.new
      #
      #   # absolute_path = File.join(Dir.home, '/var')
      #
      #   p directory
      #   ## ret = directory.set(absolute_path: absolute_path)
      #
      #   _(ret).must_equal('')
      # end
    end
  end
end
