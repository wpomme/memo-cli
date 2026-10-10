# frozen_string_literal: true

require_relative '../../../helper'

class TestSetUp < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('Models::Tag') do
    describe('#new') do
      it('Tagモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        Memo::DB::CONNECTION.transaction do |db|
          Memo::DB::Models.tag(db)

          tag = Memo::DB::Models::Tag.new

          _(tag).must_be_instance_of(Memo::DB::Models::Tag)
          _(tag).must_be_kind_of(Sequel::Model)
        end
      end
    end
  end
end
