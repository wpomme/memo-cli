# frozen_string_literal: true

require_relative "../helper"

class TestView < Minitest::Test
  describe 'View' do
    include MemoTestLifecycleHooks

    describe '#dirs' do
      it "memoの中のディレクトリの一覧を標準出力に色付きで表示する" do
        out, = capture_io do
          Memo::View.new(@test_repo).dirs
        end

        expected = Memo::Mapper.new(@test_repo).colored_dirs.to_set
        # 順番が異なっていても、書き出す内容が同じなら問題ない
        assert_equal out.split("\n").to_set, expected
      end
    end

    describe '#read' do
      it 'wordが存在するファイルと一致するとき、そのファイルを全文表示する' do
        out, = capture_io do
          Memo::View.new(@test_repo).read("push")
        end

        assert_equal Memo::MockSeed::TEST_PUSH_FILE_CONTENT, out
      end

      it 'wordが存在するファイルと複数件一致するとき、どのファイルを表示するかのプロンプトを表示し、選択したファイルを全文表示する' do
        word = 'mise'
        choices = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
          [[seed[:dir], "#{seed[:filename]}.md"].join("/"), seed[:content]] if seed[:filename] == word
        end.to_h

        $stdin = StringIO.new("2\n")
        out, = capture_io do
          Memo::View.new(@test_repo).read(word)
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

      it 'wordが存在しないファイルの場合は、そのwordにあたるメモはないことを表示する' do
        word = 'invalid_memo'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::View.new(@test_repo).read(word)
          end

          assert_equal 2, exception.status
        end

        _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub("word", word) << "\n")
      end
    end

    describe '#list' do
      it '引数がlistだけのときは、色のついたディレクトリと、そのディレクトリの中のファイルの一覧を表示する' do
        out, = capture_io do
          Memo::View.new(@test_repo).list
        end

        file_test_to_view = @test_repo.grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end

        # 順番は考慮しない
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
          Memo::View.new(@test_repo).list(valid_dir)
        end

        actual = @test_repo.grouped_file_list.filter_map { |grouped| grouped.to_view(valid_dir) }
          .flatten.join("\n") << "\n"

        _(out).must_equal(actual)
      end

      # TODO: exit 2としたい
      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'

        out, = capture_io do
          Memo::View.new(@test_repo).list(invalid_dir)
        end

        # TODO: とりあえず文字列を返すことだけを確認する
        _(out).must_be_instance_of(String)
      end
    end

    describe '#search' do
      it "受け取った文字列で全てのメモをで検索して、ヒットした行をgrep風に出力する" do
        search_word = "diff"

        out, = capture_io do
          Memo::View.new(@test_repo).search(search_word)
        end

        actual = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)
          .join("\n") << "\n"

        _(out).must_equal(actual)
      end

      it "受け取った文字列で一件もヒットしなかった場合は、その旨を知らせるメッセージを表示する" do
        search_word = "hikkakaranasounakotoba"

        out, = capture_io do
          Memo::View.new(@test_repo).search(search_word)
        end

        # TODO: とりあえず文字列を返すことを確認する
        _(out).must_be_instance_of(String)
      end
    end
  end
end
