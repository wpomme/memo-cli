# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Controller::Directory') do
    describe('#set_up') do
      it('対象のディレクトリから生成した絶対パスをテーブルに保存できること') do
        database_path = 'test_memo.db'
        db = Memo::DB::Connection.execute(database_path)

        ret = Memo::DB::Controller::Directory.new(db).set_up

        # 保存した値は一次元配列の文字列で返ってくる。全てディレクトリであるか検証する
        actual = ret.all? do |path|
          FileTest.directory?(path)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
