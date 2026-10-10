# frozen_string_literal: true

require_relative '../../helper'

class TestSetUp < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('DB::Service') do
    include Memo::Database
    include Memo::Database::Service

    # TODO: テストがBuggyになっており、修正が必要

    describe('#database_paths') do
      it('一次元配列を返し、その値はディレクトリであること') do
        actual = absolute_paths.all? do |path|
          FileTest.directory?(path)
        end

        _(actual).must_equal(true)
      end
    end
  end
end
