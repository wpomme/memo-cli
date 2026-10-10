# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('Controllers::Directory') do
    describe('#set_up') do
      it('対象のディレクトリから生成した絶対パスをテーブルに保存できること') do
        skip 'TODO'
        database_path = 'test_memo.db'
        Memo::DB::Controllers::Directory.new.set_up(database_path)
      end
    end
  end
end
