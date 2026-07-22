# frozen_string_literal: true

require_relative "../test_helper"

class TestView < Minitest::Test
  describe 'View' do
    include MemoTestLifecycleHooks

    describe '#dirs' do
      it "memoの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::View.dirs(@memo_dir)
        end

        # 順番が異なっていても、書き出す内容が同じなら問題ない
        assert_equal @dir_set, out.split("\n").to_set
      end
    end

    describe '#read' do
      it 'wordが存在するファイルと一致するとき、そのファイルを全文表示する' do
        out, = capture_io do
          Memo::View.read(@memo_dir, "find")
        end

        assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
      end

      it 'wordが存在しないファイルの場合は、そのwordにあたるメモはないことを表示する' do
        word = 'invalid_memo'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::View.read(@memo_dir, word)
          end

          assert_equal 2, exception.status
        end

        assert_equal "#{word} というメモは見つかりませんでした。\n", out
      end
    end

    describe '#list' do
      it '引数がlistだけのときは、色のついたディレクトリと、そのディレクトリの中のファイルの一覧を表示する' do
        out, = capture_io do
          Memo::View.list(@memo_dir)
        end

        # TODO: RepositoryからViewにまで渡るここら辺の処理をまとめたい
        # seeds.group_by(&:dir)はFileUtility.seeds_grouped_by_dirと同じ
        grouped_file_list = @test_repository_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename).sort
          )
        end

        file_test_to_view = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end

        # 表示される文字列が同じなら順番は関係がない
        # 集合にして同じ文字列があればよし
        actual = file_test_to_view.flatten.to_set

        # 改行で配列を作成するが、改行自身は集合に加える必要がある
        expected = out.split("\n").to_set.add("\n")
        # ユーザーに表示される票は空行が入っているので、それを取り除く
        expected.delete("")

        _(expected).must_equal(actual)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'

        out, = capture_io do
          Memo::View.list(@memo_dir, valid_dir)
        end

        grouped_file_list = @test_repository_seeds.group_by(&:dir).filter_map do |dir, seed|
          if dir == valid_dir
            Memo::Model::GroupedFileList.new(
              dir: dir,
              filenames: seed.map(&:filename).sort
            )
          end
        end

        # FIXME: 実装の方で、最後の方に余計な改行が入っているので、修正すること
        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames])
          end.flatten.join("\n") << "\n"

        _(actual).must_equal(out)
      end

      # TODO: 本当にユーザーメッセージを出すだけで、exit 2とかをしていないので直す
      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'

        out, = capture_io do
          Memo::View.list(@memo_dir, invalid_dir)
        end

        # TODO: とりあえず文字列を返すことだけを確認する
        _(out).must_be_instance_of(String)
        # assert expected.is_a?(String)
      end
    end
  end
end
