# frozen_string_literal: true

require_relative '../../../helper'

class TestDirectory < Minitest::Test
  describe('Controller::Directory') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def teardown
        Memo::Database::DB[:directories].delete
        Memo::Database::DB[:config_directories].delete
        super
      end

      # TODO: directory_seeds_resultについて、空文字を許容したため、ハッシュのキーの値が不正確になっている
      # まず、id => directory_pathというハッシュに修正する
      # その後、directory_pathからidを逆引きする場合、空文字の場合など、pathが重複する場合のロジックを修正する必要がある
      # その後、directory_seeds_resultに依存するseedsを順次修正していく
      it('全てのデータを挿入した場合、対象のディレクトリと同じ数の配列が戻り値となること') do
        config_directory_dataset = Memo::Database::Controller::ConfigDirectory.new
        directory_dataset = Memo::Database::Controller::Directory.new

        config_directory_seeds_result = config_directory_dataset.seeds

        result = directory_dataset.seeds(config_directory_seeds_result)

        actual = result.size
        expected = Memo::Database::Service.rel_paths_size

        # resultの型をチェックする
        actual_type = result.all? do |directory_path, directory_id|
          directory_path.instance_of?(String) && directory_id.instance_of?(Integer)
        end

        _(actual).must_equal(expected)
        _(actual_type).must_equal(true)
      end
    end
  end
end
