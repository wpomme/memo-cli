# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#setup') do
      it('対象のディレクトリから生成した絶対パスをテーブルに保存できること') do
        directory = Memo::Database::Controller::Directory.new

        ## TODO teardownに移動する
        # directory.delete

        ret = directory.setup

        # 保存した値は一次元配列の文字列で返ってくる。全てディレクトリであるか検証する
        actual = ret.all? do |path|
          FileTest.directory?(path)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
