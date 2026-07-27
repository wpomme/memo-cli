# frozen_string_literal: true

require_relative "../helper"

class TestCommand < Minitest::Test
  describe 'Command' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe '#execute' do
      describe 'args: dirs' do
        it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
          out, = capture_io do
            Memo::Command.new(@repo).execute(['dirs'])
          end

          expected = Memo::Mapper.new(@repo).colored_dirs.to_set
          assert_equal out.split("\n").to_set, expected
        end
      end

      describe 'args: list' do
        it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
          out, = capture_io do
            Memo::Command.new(@repo).execute(['list'])
          end

          file_test_to_view = grouped_file_list(@test_seeds)
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
            Memo::Command.new(@repo).execute(['list', valid_dir])
          end

          grouped_file_list_by_dir = @test_seeds.group_by(&:dir).filter_map do |dir, seed|
            if dir == valid_dir
              Memo::Model::GroupedFileList.new(
                dir: dir,
                filenames: seed.map(&:filename).sort
              )
            end
          end

          # FIXME: 実装の方で、最後の方に余計な改行が入っているので、修正すること
          actual = grouped_file_list_by_dir
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
        it "['read', 'push']を受け取ったときは、push.mdを全文表示する" do
          out, = capture_io do
            Memo::Command.new(@repo).execute(%w[read push])
          end

          assert_equal Memo::MockSeed::TEST_PUSH_FILE_CONTENT, out
        end

        it "['read', 'invalid_memo']を受け取ったときは、そのようなメモがないことを表示する" do
          word = 'invalid_memo'

          out, = capture_io do
            exception = assert_raises(SystemExit) do
              Memo::Command.new(@repo).execute(%w[read invalid_memo])
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
              Memo::Command.new(@repo).execute(['read', word])
            end

            assert_equal "invalid argument: -r ", exception.message
          end
        end
      end

      describe 'args: search' do
        it "['search', 'diff']を受け取ったときは、全てのメモの中でdiffが入っている行を色付きで表示する" do
          search_word = 'diff'

          out, = capture_io do
            Memo::Command.new(@repo).execute(["search", search_word])
          end

          actual = Memo::Mapper.new(@repo).search_result_to_view(search_word)
            .join("\n") << "\n"

          _(out).must_equal(actual)
        end

        it "['search', 'hikkakaranasounakotoba']を受け取ったときは、そのようなメモがないことを表示する" do
          search_word = 'hikkakaranasounakotoba'

          out, = capture_io do
            Memo::Command.new(@repo).execute(["search", search_word])
          end

          assert_equal out, "#{search_word}で全ファイル検索しましたが、そのような文字列は見当たりませんでした。\n"
        end

        it "['search', nil]を受け取ったときは、例外を送出する" do
          word = nil

          capture_io do
            exception = assert_raises(OptionParser::InvalidArgument) do
              Memo::Command.new(@repo).execute(['search', word])
            end

            assert_equal "invalid argument: -s ", exception.message
          end
        end
      end
    end
  end
end
