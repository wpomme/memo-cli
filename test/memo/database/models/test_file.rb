# frozen_string_literal: true

require_relative '../../../helper'

class TestSetUp < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Models::File') do
    describe('#new') do
      it('Fileモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        file = Memo::Database::Models::File.new

        _(file).must_be_instance_of(Memo::Database::Models::File)
        _(file).must_be_kind_of(Sequel::Model)
      end
    end
  end
end
