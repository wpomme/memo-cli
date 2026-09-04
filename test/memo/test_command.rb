# frozen_string_literal: true

require_relative "../helper"

class TestCommand < Minitest::Test
  describe 'Command' do
    include MemoTestLifecycleHooks

    describe '#execute' do
      describe 'argv: dirs' do
        it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
          out, = capture_io do
            Memo::Command.new(@test_repo).execute(['dirs'])
          end

          expected = Memo::Mapper.new(@test_repo).colored_dirs.to_set
          assert_equal out.split("\n").to_set, expected
        end
      end

      describe 'argv: list' do
        it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
          out, = capture_io do
            Memo::Command.new(@test_repo).execute(['list'])
          end

          # 順番は考慮しない
          actual = @test_repo.grouped_file_list.map(&:to_view)
            .flatten.to_set

          expected = out.split("\n").to_set
          # 空行を取り除く
          expected.delete("")

          _(expected).must_equal(actual)
        end

        it "['list', 'cli']を受け取ったときは、memo_dirの中のcliディレクトリの中にあるメモファイルを全て表示する" do
          valid_dir = 'cli'

          out, = capture_io do
            Memo::Command.new(@test_repo).execute(['list', valid_dir])
          end

          actual = @test_repo.grouped_file_list.filter_map { |grouped| grouped.to_view(valid_dir) }
            .flatten.join("\n") << "\n"

          _(out).must_equal(actual)
        end

        it "['list', 'invalid_dir']の場合、ユーザーメッセージ" do
          skip "TODO"
        end
      end

      describe 'argv: read' do
        it "['read', 'diff']を受け取ったときは、diff.mdを全文表示する" do
          out, = capture_io do
            Memo::Command.new(@test_repo).execute(%w[read diff])
          end

          assert_equal Memo::MockSeed::TEST_DIFF_FILE_CONTENT, out
        end

        it "['read', 'mise']を受け取ったときは、プロンプトを表示した後、選択した方のmise.mdを全文表示する" do
          word = 'mise'
          choices = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
            [[seed[:dir], "#{seed[:filename]}.md"].join("/"), seed[:content]] if seed[:filename] == word
          end.to_h
          $stdin = StringIO.new("2\n")

          out, = capture_io do
            Memo::Command.new(@test_repo).execute(%w[read mise])
          end

          title = Memo::Message::MULTIPLE_MEMOS_WEWE_FOUND.sub("size", choices.size.to_s)
          choices_out = choices.keys.map.with_index do |key, index|
            "[#{index + 1}] #{key}"
          end
          content = Memo::MockSeed::TEST_MISE_FILE_CONTENT_2

          _(out).must_equal([title].concat(choices_out).push(content).join("\n"))
        ensure
          $stdin = STDIN
        end

        it "['read', 'invalid_memo']を受け取ったときは、そのようなメモがないことを表示する" do
          word = 'invalid_memo'

          out, = capture_io do
            exception = assert_raises(SystemExit) do
              Memo::Command.new(@test_repo).execute(%w[read invalid_memo])
            end

            assert_equal 2, exception.status
          end

          _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub("word", word) << "\n")
        end

        it "['read', nil]を受け取ったときは、例外を送出する" do
          word = nil

          capture_io do
            exception = assert_raises(OptionParser::InvalidArgument) do
              Memo::Command.new(@test_repo).execute(['read', word])
            end

            assert_equal "invalid argument: -r ", exception.message
          end
        end
      end

      describe 'argv: search' do
        it "['search', 'diff']を受け取ったときは、全てのメモの中でdiffが入っている行を色付きで表示する" do
          search_word = 'diff'

          out, = capture_io do
            Memo::Command.new(@test_repo).execute(["search", search_word])
          end

          actual = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)
            .join("\n") << "\n"

          _(out).must_equal(actual)
        end

        it "['search', 'hikkakaranasounakotoba']を受け取ったときは、そのようなメモがないことを表示する" do
          search_word = 'hikkakaranasounakotoba'

          out, = capture_io do
            Memo::Command.new(@test_repo).execute(["search", search_word])
          end

          assert_equal out, Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word) << "\n"
        end

        it "['search', nil]を受け取ったときは、例外を送出する" do
          word = nil

          capture_io do
            exception = assert_raises(OptionParser::InvalidArgument) do
              Memo::Command.new(@test_repo).execute(['search', word])
            end

            assert_equal "invalid argument: -s ", exception.message
          end
        end
      end
    end
  end
end
