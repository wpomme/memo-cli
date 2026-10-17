# frozen_string_literal: true

require_relative '../../../helper'

class TestFile < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Model::File') do
    describe('#new') do
      it('Fileモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        skip 'TODO'
        file = Memo::Database::Model::File.new

        _(file).must_be_instance_of(Memo::Database::Model::File)
        _(file).must_be_kind_of(Sequel::Model)
      end
    end
  end
end
