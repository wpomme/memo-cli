# frozen_string_literal: true

require_relative "../test_helper"

class TestViewModel < Minitest::Test
  describe 'ViewModel' do
    include MemoTestLifecycleHooks

    describe '#file_list_to_presenter' do
      it "Repositoryから受け取ったグループ化されたファイル名の一覧をPresenterで表示しやすくする" do
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
    end
  end
end
