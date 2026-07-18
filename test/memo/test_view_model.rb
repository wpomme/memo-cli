# frozen_string_literal: true

require_relative "../test_helper"

class TestViewModel < Minitest::Test
  describe 'ViewModel' do
    include MemoTestLifecycleHooks

    describe '#file_list_to_presenter' do
      # ディレクトリを緑色にするなど
      it "グループ化されたファイル名の一覧をPresenterで表示しやすくする" do
        expected = Memo::ViewModel.file_list_to_presenter(@memo_dir)

        # entries.group_by(&:dir)はMemoFileUtility.entries_grouped_by_dirと同じ
        grouped_file_list = @test_repository_entries.group_by(&:dir).map do |dir, entry|
          Memo::GroupedFileList.new(
            dir: dir,
            filenames: entry.map(&:filename).sort
          )
        end

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end.flatten

        actual.pop

        _(actual).must_equal(expected)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'
        expected = Memo::ViewModel.file_list_to_presenter(@memo_dir, valid_dir)

        grouped_file_list = @test_repository_entries.group_by(&:dir).filter_map do |dir, entry|
          if dir == valid_dir
            Memo::GroupedFileList.new(
              dir: dir,
              filenames: entry.map(&:filename).sort
            )
          end
        end

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end.flatten

        actual.pop

        _(actual).must_equal(expected)
      end

      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'
        expected = Memo::ViewModel.file_list_to_presenter(@memo_dir, invalid_dir)

        # TODO: とりあえず文字列を返すことだけを確認する
        assert expected.is_a?(String)
      end
    end
  end
end
