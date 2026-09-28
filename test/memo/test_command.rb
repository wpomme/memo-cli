# frozen_string_literal: true

require_relative '../helper'

class TestCommand < Minitest::Test
  describe 'Command' do
    include MemoTestLifecycleHooks

    it 'SKIP: COMMAND' do
      skip 'SKIP: TODO: COMMAND'

      describe '#execute' do
        describe 'argv: dirs' do
          it "['dirs']を受け取ったときは、対象のディレクトリの中のディレクトリ一覧をターミナルに表示する" do
            out, = capture_io do
              Memo::Command.new(@test_repo).execute(['dirs'])
            end

            expected = Memo::Mapper.new(@test_repo).dirs_to_view << "\n"
            _(out).must_equal(expected)
          end
        end

        describe 'argv: list' do
          it "['list']を受け取ったときは、対象ディレクトリの中のディレクトリとその中にあるメモファイルを全て表示する" do
            out, = capture_io do
              Memo::Command.new(@test_repo).execute(['list'])
            end

            grouped_ls_to_view = Memo::Mapper.new(@test_repo).grouped_ls_to_view

            actual = grouped_ls_to_view.to_set

            expected = out.split("\n").to_set

            _(actual).must_equal(expected)
          end

          it "['list', 'cli']を受け取ったときは、対象ディレクトリの中のcliディレクトリの中にあるメモファイルとディレクトリを全て表示する" do
            valid_dir = 'cli'

            out, = capture_io do
              Memo::Command.new(@test_repo).execute(['list', valid_dir])
            end

            grouped_ls_to_view = Memo::Mapper.new(@test_repo).grouped_ls_to_view(valid_dir)

            actual = grouped_ls_to_view.to_set

            expected = out.split("\n").to_set

            _(actual).must_equal(expected)
          end

          it "['list', 'invalid_dir']の場合、そのようなディレクトリが存在しない旨のメッセージを表示する" do
            invalid_dir = 'invalid_dir'

            out, = capture_io do
              Memo::Command.new(@test_repo).execute(['list', invalid_dir])
            end

            expected = Memo::Message::NO_DIRECTORIES.sub('dir', invalid_dir) << @test_repo.dir_set.join(' ') << "\n"

            _(out).must_equal(expected)
          end
        end

        describe 'argv: read' do
          it "['read', 'ls']を受け取ったときは、ls.mdを全文表示する" do
            out, = capture_io do
              Memo::Command.new(@test_repo).execute(%w[read ls])
            end

            assert_equal Memo::MockSeed::TEST_LS_FILE_CONTENT, out
          end

          it "['read', 'mise']を受け取ったときは、プロンプトを表示した後、選択した方のmise.mdを全文表示する" do
            word = @fixed_duplicated_filename
            choices = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
              [[seed[:parent_dir], "#{seed[:basename]}.md"].join('/'), seed[:content]] if seed[:basename] == word
            end.to_h
            $stdin = StringIO.new("2\n")

            out, = capture_io do
              Memo::Command.new(@test_repo).execute(%w[read mise])
            end

            title = Memo::Message::MULTIPLE_MEMOS_WEWE_FOUND.sub('size', choices.size.to_s)
            choices_out = choices.keys.map.with_index do |key, index|
              "[#{index + 1}] #{key}"
            end
            content = Memo::MockSeed::TEST_SETTING_MISE_FILE_CONTENT

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

            _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word) << "\n")
          end

          it "['read', nil]を受け取ったときは、例外を送出する" do
            word = nil

            capture_io do
              exception = assert_raises(OptionParser::InvalidArgument) do
                Memo::Command.new(@test_repo).execute(['read', word])
              end

              assert_equal 'invalid argument: -r ', exception.message
            end
          end
        end

        describe 'argv: search' do
          it "['search', 'ls']を受け取ったときは、全てのメモの中でlsが入っている行を色付きで表示する" do
            search_word = @fixed_search_word

            out, = capture_io do
              Memo::Command.new(@test_repo).execute(['search', search_word])
            end

            actual = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)
              .join("\n") << "\n"

            _(out).must_equal(actual)
          end

          it "['search', 'hikkakaranasounakotoba']を受け取ったときは、そのようなメモがないことを表示する" do
            search_word = 'hikkakaranasounakotoba'

            out, = capture_io do
              Memo::Command.new(@test_repo).execute(['search', search_word])
            end

            assert_equal out, Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word) << "\n"
          end

          it "['search', nil]を受け取ったときは、例外を送出する" do
            word = nil

            capture_io do
              exception = assert_raises(OptionParser::InvalidArgument) do
                Memo::Command.new(@test_repo).execute(['search', word])
              end

              assert_equal 'invalid argument: -s ', exception.message
            end
          end
        end

        describe 'argv: tag' do
          it "['tag', 'cli']を受け取ったときは、色付けされたタグ名とそのタグが付いたファイル名の一覧を表示する" do
            tag = 'CLI'

            actual, = capture_io do
              Memo::Command.new(@test_repo).execute(%w[tag CLI])
            end

            expected = Memo::Mapper.new(@test_repo).tag_and_filenames_by_tag_to_view(tag).join("\n") << "\n"

            _(actual).must_equal(expected)
          end

          it "['tag', 'does_not_exist_tag_name']を受け取ったときは、そのようなタグ名が存在しないことをユーザーに知らせるメッセージを表示する" do
            tag = 'CLI'

            actual, = capture_io do
              Memo::Command.new(@test_repo).execute(%w[tag does_not_exist_tag_name])
            end

            expected = Memo::Message::NO_TAGS.sub('tag', tag) << @test_repo.tag_list.join(Memo::Mapper::INDENT) << "\n"

            _(actual).must_equal(expected)
          end

          it "['tag']だけを受け取ったときは、タグ名を与えなければいけないことをユーザーに知らせるメッセージを表示する" do
            actual, = capture_io do
              Memo::Command.new(@test_repo).execute(['tag'])
            end

            expected = Memo::Message::NO_GIVEN_TAGS

            _(actual).must_equal(expected)
          end
        end

        describe 'argv: tags' do
          it "['tags']を受け取ったときは、色付けされたタグ名とそのタグが付いたファイル名の一覧を表示する" do
            actual, = capture_io do
              Memo::Command.new(@test_repo).execute(['tags'])
            end

            expected = Memo::Mapper.new(@test_repo).tag_and_filenames_to_view
              .join("\n") << "\n"

            _(actual).must_equal(expected)
          end
        end
      end
    end
  end
end
