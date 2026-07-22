# frozen_string_literal: true

require_relative "../test_helper"

class TestCommand < Minitest::Test
  describe 'Command' do
    include MemoTestLifecycleHooks

    describe '#execute' do
      describe 'args: dirs' do
        it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(['dirs'])
          end

          actual = @dir_set
          assert_equal actual, out.split("\n").to_set
        end
      end

      describe 'args: list' do
        it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(['list'])
          end

          # TODO: RepositoryからCommandにまで渡るここら辺の処理をまとめたい
          # entries.group_by(&:dir)はFileUtility.entries_grouped_by_dirと同じ
          grouped_file_list = @test_repository_entries.group_by(&:dir).map do |dir, seed|
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

        it "['list', 'cli']を受け取ったときは、memo_dirの中のcliディレクトリの中にあるメモファイルを全て表示する" do
          valid_dir = 'cli'

          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(['list', valid_dir])
          end

          grouped_file_list = @test_repository_entries.group_by(&:dir).filter_map do |dir, seed|
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

        it "['list', 'invalid_dir']の場合、ユーザーメッセージ" do
          skip "TODO"
        end
      end

      describe 'args: read' do
        it "['read', 'find']を受け取ったときは、find.mdを全文表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(%w[read find])
          end

          assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
        end

        it "['read', 'invalid_memo']を受け取ったときは、そのようなメモがないことを表示する" do
          word = 'invalid_memo'

          out, = capture_io do
            exception = assert_raises(SystemExit) do
              Memo::Command.new(@memo_dir).execute(%w[read invalid_memo])
            end

            assert_equal 2, exception.status
          end

          assert_equal "#{word} というメモは見つかりませんでした。\n", out
        end

        # Memo::Command以下のParserの動作みたい
        it "['read', nil]を受け取ったときは、例外を送出する" do
          word = nil

          capture_io do
            exception = assert_raises(OptionParser::InvalidArgument) do
              Memo::Command.new(@memo_dir).execute(['read', word])
            end

            assert_equal "invalid argument: -r ", exception.message
          end
        end
      end
    end
  end
end
