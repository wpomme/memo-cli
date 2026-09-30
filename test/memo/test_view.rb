# frozen_string_literal: true

require_relative '../helper'

class TestView < Minitest::Test
  describe 'View' do
    include MemoTestLifecycleHooks

    describe '#dirs' do
      it 'memoの中のディレクトリの一覧をターミナルに表示する' do
        out, = capture_io do
          Memo::View.new(@test_repo).dirs
        end

        expected = Memo::Mapper.new(@test_repo).dirs_to_view << "\n"
        _(out).must_equal(expected)
      end
    end

    describe '#read' do
      it 'wordが存在するファイルと一致するとき、そのファイルを全文表示する' do
        skip 'TODO'

        out, = capture_io do
          Memo::View.new(@test_repo).read(@fixed_mock_file)
        end

        _(out).must_equal(Memo::MockSeed::TEST_LS_FILE_CONTENT)
      end

      it 'wordが存在するファイルと複数件一致するとき、どのファイルを表示するかのプロンプトを表示し、選択したファイルを全文表示する' do
        skip 'TODO'

        word = @fixed_duplicated_filename
        choices = Memo::MockSeed::TEST_MEMO_DATA_SEED.filter_map do |seed|
          [[seed[:parent_dir], "#{seed[:basename]}.md"].join('/'), seed[:content]] if seed[:basename] == word
        end.to_h

        $stdin = StringIO.new("2\n")
        out, = capture_io do
          Memo::View.new(@test_repo).read(word)
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

      it 'wordが存在しないファイルの場合は、そのwordにあたるメモはないことを表示する' do
        word = 'invalid_memo'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::View.new(@test_repo).read(word)
          end

          assert_equal 2, exception.status
        end

        _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word) << "\n")
      end
    end

    describe '#list' do
      it '引数がlistだけのときは、色のついたディレクトリと、そのディレクトリの中のファイルの一覧を表示する' do
        out, = capture_io do
          Memo::View.new(@test_repo).list
        end

        grouped_ls_to_view = Memo::Mapper.new(@test_repo).grouped_ls_to_view

        actual = grouped_ls_to_view.to_set

        expected = out.split("\n").to_set

        _(actual).must_equal(expected)
      end

      it '有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する' do
        valid_dir = 'cli'

        out, = capture_io do
          Memo::View.new(@test_repo).list(valid_dir)
        end

        grouped_ls_to_view = Memo::Mapper.new(@test_repo).grouped_ls_to_view(valid_dir)

        actual = grouped_ls_to_view.to_set

        expected = out.split("\n").to_set

        _(actual).must_equal(expected)
      end

      # TODO: exit 2としたい
      it '存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す' do
        invalid_dir = 'invalid_dir'

        out, = capture_io do
          Memo::View.new(@test_repo).list(invalid_dir)
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
            Memo::View.new(@test_repo).tag(tag)
          end

          expected = Memo::Mapper.new(@test_repo).tag_and_filenames_by_tag_to_view(tag).join("\n") << "\n"

          _(actual).must_equal(expected)
        end
      end

      describe '存在しないタグ名が与えられた場合' do
        tag = 'does_not_exist_tag_name'

        it 'そのようなタグ名が存在しないことをユーザーに知らせるメッセージを表示する' do
          actual, = capture_io do
            Memo::View.new(@test_repo).tag(tag)
          end

          expected = Memo::Message::NO_TAGS.sub('tag', tag) << @test_repo.tag_list.join(Memo::Mapper::INDENT) << "\n"

          _(actual).must_equal(expected)
        end
      end

      describe 'タグ名が与えられなかった場合' do
        it 'タグ名を与えなければいけないことをユーザーに知らせるメッセージを表示する' do
          actual, = capture_io do
            Memo::View.new(@test_repo).tag
          end

          expected = Memo::Message::NO_GIVEN_TAGS

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#tags' do
      describe '引数が与えられなかった場合' do
        it '色付けされたタグ名とそのタグが付いたファイル名の一覧を表示する' do
          actual, = capture_io do
            Memo::View.new(@test_repo).tags
          end

          expected = Memo::Mapper.new(@test_repo).tag_and_filenames_to_view.join("\n") << "\n"

          _(actual).must_equal(expected)
        end
      end

      describe '引数が与えられた場合' do
        it ':listなら、タグ名だけを返す' do
          actual, = capture_io do
            Memo::View.new(@test_repo).tags(:list)
          end

          expected = @test_repo.tag_list.join(' ') << "\n"

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#search' do
      it '受け取った文字列で全てのメモをで検索して、ヒットした行をgrep風に出力する' do
        search_word = @fixed_search_word

        out, = capture_io do
          Memo::View.new(@test_repo).search(search_word)
        end

        actual = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)
          .join("\n") << "\n"

        _(out).must_equal(actual)
      end

      it '受け取った文字列で一件もヒットしなかった場合は、その旨を知らせるメッセージを表示する' do
        search_word = 'hikkakaranasounakotoba'

        out, = capture_io do
          Memo::View.new(@test_repo).search(search_word)
        end

        # TODO: とりあえず文字列を返すことを確認する
        _(out).must_be_instance_of(String)
      end
    end
  end
end
