# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Model::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#directory') do
      it('Directoryモデルのインスタンスを動的に作成できること。そのモデルのスーパークラスがSequel::Modelであること') do
        skip 'TODO'
        # Directoryクラスを動的に生成する
        # Memo::DB::Model.directory

        directory = Memo::Database::Model::Directory.new

        _(directory).must_be_instance_of(Memo::Database::Model::Directory)
        _(directory).must_be_kind_of(Sequel::Model)
      end
    end
  end
end
