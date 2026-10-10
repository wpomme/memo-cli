# frozen_string_literal: true

class TestSetUp < Minitest::Test
  describe('DB::Service') do
    include Memo::DB::Service

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
