# frozen_string_literal: true

require_relative '../../../helper'

class TestSetUp < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#set_up') do
      it('対象のディレクトリから生成した絶対パスをテーブルに保存できること') do
        skip 'TODO'
        directory = Memo::DB::Models.directory

        ## TODO teardownに移動する
        directory.delete

        ret = directory.set_up

        # 保存した値は一次元配列の文字列で返ってくる。全てディレクトリであるか検証する
        actual = ret.all? do |path|
          FileTest.directory?(path)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
