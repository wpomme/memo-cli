# frozen_string_literal: true

require_relative "../helper"

class TestMapper < Minitest::Test
  describe 'Mapper' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe '#file_list_to_view' do
      it "グループ化されたファイル名の一覧をViewで表示しやすくする" do
        expected = Memo::Mapper.new(@repo).file_list_to_view

        grouped_file_list = grouped_file_list(@test_seeds)

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green] + struct[:filenames]
          end

        _(expected).must_equal(actual)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'
        expected = Memo::Mapper.new(@repo).file_list_to_view(valid_dir)

        grouped_file_list = grouped_file_list(@test_seeds)

        actual = grouped_file_list
          .filter_map do |struct|
            [Rainbow(struct[:dir]).green] + struct[:filenames] if struct[:dir] == valid_dir
          end

        _(expected).must_equal(actual)
      end

      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'
        expected = Memo::Mapper.new(@repo).file_list_to_view(invalid_dir)

        # TODO: とりあえず文字列を返すことだけを確認する
        assert expected.is_a?(String)
      end
    end
  end
end
