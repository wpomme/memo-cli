# frozen_string_literal: true

require_relative '../../../helper'

class TestTag < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Model::Tag') do
    describe('#new') do
      it('Tagモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        tag = Memo::Database::Model::Tag.new

        _(tag).must_be_instance_of(Memo::Database::Model::Tag)
        _(tag).must_be_kind_of(Sequel::Model)
      end
    end
  end
end
