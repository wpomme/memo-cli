# frozen_string_literal: true

require_relative "../test_helper"

class TestPresenter < Minitest::Test
  describe 'Presenter' do
    include MemoTestLifecycleHooks

    describe '#dirs' do
      it "memoの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::Presenter.dirs(@memo_dir)
        end

        # 順番が異なっていても、書き出す内容が同じなら問題ない
        assert_equal @dir_set, out.split("\n").to_set
      end
    end

    describe '#read' do
      it 'wordが存在するファイルと一致するとき、そのファイルを全文表示する' do
        out, = capture_io do
          Memo::Presenter.read(@memo_dir, "find")
        end

        assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
      end

      it 'wordが存在しないファイルの場合は、そのwordにあたるメモはないことを表示する' do
        word = 'invalid_memo'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::Presenter.read(@memo_dir, word)
          end

          assert_equal 2, exception.status
        end

        assert_equal "#{word} というメモは見つかりませんでした。\n", out
      end
    end

    describe '#list' do
      it '引数がlistだけのときは、色のついたディレクトリと、そのディレクトリの中のファイルの一覧を表示する' do
        out, = capture_io do
          Memo::Presenter.list(@memo_dir)
        end

        # TODO: RepositoryからPresenterにまで渡るここら辺の処理をまとめたい
        # entries.group_by(&:dir)はMemoFileUtility.entries_grouped_by_dirと同じ
        grouped_file_list = @test_repository_entries.group_by(&:dir).map do |dir, entry|
          Memo::GroupedFileList.new(
            dir: dir,
            filenames: entry.map(&:filename).sort
          )
        end

        file_test_to_presenter = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end

        # 表示される文字列が同じなら順番は関係がない
        # 集合にして同じ文字列があればよし
        actual = file_test_to_presenter.flatten.to_set

        # 改行で配列を作成するが、改行自身は集合に加える必要がある
        expected = out.split("\n").to_set.add("\n")
        # ユーザーに表示される票は空行が入っているので、それを取り除く
        expected.delete("")

        _(expected).must_equal(actual)
      end
    end
  end
end
