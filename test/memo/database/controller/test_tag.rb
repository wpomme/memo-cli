# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Tag') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:tags].delete
        super
      end

      it('全てのデータを挿入した場合、IDとタグ名のハッシュが戻り値となること') do
        dataset = Memo::Database::Controller::Tag.new
        result = dataset.seeds

        # 挿入する前のデータの数と挿入されたデータの数が等しいかどうかも検証する
        actual_size = result.size

        file_loader = Memo::Database::FileLoader.new
        expected_size = file_loader.all_tags.size

        # load_filesが呼ばれた回数が一回であることを確認する
        actual_called_count = file_loader.instance_variable_get(:@method_called_count)

        expected_called_count = 1

        # resultの型をチェックする
        actual_type = result.all? do |tag_id, tag_name|
          tag_id.instance_of?(Integer) && tag_name.instance_of?(String)
        end

        _(actual_size).must_equal(expected_size)
        _(actual_type).must_equal(true)
        _(actual_called_count).must_equal(expected_called_count)
      end
    end
  end
end
