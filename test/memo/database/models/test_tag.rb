# frozen_string_literal: true

require_relative '../../../helper'

class TestSetUp < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Models::Tag') do
    describe('#new') do
      it('Tagモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        tag = Memo::Database::Models::Tag.new

        _(tag).must_be_instance_of(Memo::Database::Models::Tag)
        _(tag).must_be_kind_of(Sequel::Model)
      end
    end
  end
end
