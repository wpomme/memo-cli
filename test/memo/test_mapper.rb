# frozen_string_literal: true

require_relative "../helper"

class TestMapper < Minitest::Test
  describe 'Mapper' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe '#file_list_to_view' do
      it "グループ化されたファイル名の一覧をViewで表示しやすくする" do
        expected = Memo::Mapper.new(@test_repo).file_list_to_view

        grouped_file_list = grouped_file_list(@test_seeds)

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green] + struct[:filenames]
          end

        _(expected).must_equal(actual)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'
        expected = Memo::Mapper.new(@test_repo).file_list_to_view(valid_dir)

        grouped_file_list = grouped_file_list(@test_seeds)

        actual = grouped_file_list
          .filter_map do |struct|
            [Rainbow(struct[:dir]).green] + struct[:filenames] if struct[:dir] == valid_dir
          end

        _(expected).must_equal(actual)
      end

      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'
        expected = Memo::Mapper.new(@test_repo).file_list_to_view(invalid_dir)

        # TODO: とりあえず文字列を返すことだけを確認する
        assert expected.is_a?(String)
      end
    end

    describe '#search_result_to_view' do
      describe '戻り値の型検査' do
        it '色付きの検索結果が含まれている文字列の一次元配列を返す' do
          search_word = 'diff'
          result = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)

          expected = result.all? do |memo|
            memo.instance_of?(String)
            memo.include?(Rainbow(search_word).red)
          end

          _(expected).must_equal(true)
        end

        it '検索結果がなかった場合は、文字列を返す' do
          search_word = 'hikkakaranasounakotoba'
          expected = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)

          _(expected).must_be_instance_of(String)
        end
      end

      describe '戻り値の値検査' do
        it '検索でヒットした文字列に色を付けて値を返す' do
          search_word = 'diff'
          expected = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)

          actual = @test_repo.search_all(search_word).flatten.map do |line|
            line.to_view(search_word)
          end

          _(expected).must_equal(actual)
        end

        it '検索結果がなかった場合は、その旨を知らせる文字列を返す' do
          search_word = 'hikkakaranasounakotoba'
          expected = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)
          actual = Memo::Mapper::NOT_FOUND_MESSAGE.sub('word', search_word)

          _(expected).must_equal(actual)
        end
      end
    end
  end
end
