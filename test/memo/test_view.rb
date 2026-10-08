# frozen_string_literal: true

require_relative '../helper'

class TestView < Minitest::Test
  describe 'View' do
    include MemoTestLifecycleHooks

    def setup
      super

      @mapper = Memo::Mapper.new(@test_repo)
      @view = Memo::View.new(@test_repo)
    end

    describe '#dirs' do
      it 'memoの中のディレクトリの一覧をターミナルに表示する' do
        out, = capture_io do
          @view.dirs
        end

        expected = @mapper.dirs_to_view << "\n"
        _(out).must_equal(expected)
      end
    end

    describe '#read' do
      it 'target_filenameが存在するファイルと一致するとき、そのファイルを全文表示する' do
        target_file = @fixed_mock_file
        out, = capture_io do
          @view.read(target_file)
        end

        _(out).must_equal(Memo::MockSeed::TEST_MEMO_DATA_SEED.find { |seed| seed[:basename] == target_file }[:content])
      end

      it 'target_filenameが存在するファイルと複数件一致するとき、どのファイルを表示するかのプロンプトを表示し、選択したファイルを全文表示する' do
        target_filename = @fixed_duplicated_filename

        choices = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
          [[seed[:parent_dir], "#{seed[:basename]}.md"].join('/'), seed[:content]] if seed[:basename] == target_filename
        end.to_h

        count = choices.size.to_s

        # 最後の方を選択する
        $stdin = StringIO.new("#{count}\n")
        out, = capture_io do
          @view.read(target_filename)
        end

        title = Memo::Message::MULTIPLE_MEMOS_WEWE_FOUND.sub('size', count)
        choices_out = choices.keys.map.with_index do |key, index|
          "[#{index + 1}] #{key}"
        end

        target_seeds = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter do |seed|
          seed[:basename] == target_filename
        end

        content = target_seeds[-1][:content]

        _(out).must_equal([title].concat(choices_out).push(content).join("\n"))
      ensure
        $stdin = STDIN
      end

      it '引数が与えられていない場合は、その旨をユーザーに知らせるメッセージを返す' do
        out, = capture_io do
          @view.read
        end

        expected = Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'read')

        _(out).must_equal(expected)
      end

      it 'wordが存在しないファイルの場合は、そのwordにあたるメモはないことを表示する' do
        word = 'invalid_memo'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            @view.read(word)
          end

          assert_equal 2, exception.status
        end

        _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word) << "\n")
      end
    end

    describe '#list' do
      it '引数がlistだけのときは、色のついたディレクトリと、そのディレクトリの中のファイルの一覧を表示する' do
        out, = capture_io do
          @view.list
        end

        actual = out

        expected = @mapper.grouped_ls_to_view.join("\n").gsub("\n\n", "\n") << "\n"

        _(actual).must_equal(expected)
      end

      it '有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する' do
        valid_dir = 'cli'

        out, = capture_io do
          @view.list(valid_dir)
        end

        actual = out

        expected = @mapper.grouped_ls_to_view(valid_dir).join("\n")

        _(actual).must_equal(expected)
      end

      # TODO: exit 2としたい
      it '存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す' do
        invalid_dir = 'invalid_dir'

        out, = capture_io do
          @view.list(invalid_dir)
        end

        expected = Memo::Message::NO_DIRECTORIES.sub('dir', invalid_dir) << @test_repo.dir_set.join(' ') << "\n"

        _(out).must_equal(expected)
      end
    end

    describe '#tag' do
      describe '存在するタグ名が与えられた場合' do
        tag = 'CLI'

        it '色付けされたタグ名とそのタグが付いたファイル名の一覧を表示する' do
          actual, = capture_io do
            @view.tag(tag)
          end

          expected = @mapper.tag_and_filenames_by_tag_to_view(tag).join("\n") << "\n"

          _(actual).must_equal(expected)
        end
      end

      describe '存在しないタグ名が与えられた場合' do
        tag = 'does_not_exist_tag_name'

        it 'そのようなタグ名が存在しないことをユーザーに知らせるメッセージを表示する' do
          actual, = capture_io do
            @view.tag(tag)
          end

          expected = Memo::Message::NO_TAGS.sub('tag', tag) << @test_repo.tag_list.join(Memo::Mapper::INDENT) << "\n"

          _(actual).must_equal(expected)
        end
      end

      describe 'タグ名が与えられなかった場合' do
        it 'タグ名を与えなければいけないことをユーザーに知らせるメッセージを表示する' do
          actual, = capture_io do
            @view.tag
          end

          expected = Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'tag')

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#tags' do
      describe '引数が与えられなかった場合' do
        it '色付けされたタグ名とそのタグが付いたファイル名の一覧を表示する' do
          actual, = capture_io do
            @view.tags
          end

          expected = @mapper.tag_and_filenames_to_view.join("\n").gsub("\n\n", "\n") << "\n"

          _(actual).must_equal(expected)
        end
      end

      describe '引数が与えられた場合' do
        it ':nameなら、タグ名だけを返す' do
          actual, = capture_io do
            @view.tags(:name)
          end

          expected = @test_repo.tag_list.join("\n") << "\n"

          _(actual).must_equal(expected)
        end

        describe ':empty' do
          it 'タグ付けされていないファイル名の一覧を返す。そのようなファイル名がなければその旨のメッセージを表示する' do
            actual, = capture_io do
              @view.tags(:empty)
            end

            expected = if @test_repo.empty_tags_file_list.empty?
                         Memo::Message::NO_EMPTY_TAGS_FILE_LIST
                       else
                         @mapper.empty_tags_file_list_to_view.join("\n").gsub("\n\n", "\n") << "\n"
                       end

            _(actual).must_equal(expected)
          end
        end

        describe ':count' do
          it 'タグの出現回数を表示する' do
            actual, = capture_io do
              @view.tags(:count)
            end

            expected = @mapper.count_of_each_tag_to_view.join("\n") << "\n"

            _(actual).must_equal(expected)
          end
        end
      end
    end

    describe '#search' do
      it '受け取った文字列で全てのメモをで検索して、ヒットした行をgrep風に出力する' do
        search_word = @fixed_search_word

        out, = capture_io do
          @view.search(search_word)
        end

        actual = @mapper.search_result_to_view(search_word)
          .join("\n") << "\n"

        _(out).must_equal(actual)
      end

      it '受け取った文字列で一件もヒットしなかった場合は、その旨を知らせるメッセージを表示する' do
        search_word = 'hikkakaranasounakotoba'

        out, = capture_io do
          @view.search(search_word)
        end

        expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word) << "\n"

        _(out).must_equal(expected)
      end

      it '引数が与えられなかった場合は、その旨を知らせるメッセージを表示する' do
        out, = capture_io do
          @view.search
        end

        expected = Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'search')

        _(out).must_equal(expected)
      end
    end
  end
end
