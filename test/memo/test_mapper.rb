# frozen_string_literal: true

require_relative "../helper"

class TestMapper < Minitest::Test
  describe 'Mapper' do
    include MemoTestLifecycleHooks

    describe "#grouped_ls_to_view" do
      describe "引数を取らない場合" do
        describe "戻り値の型検査" do
          it "戻り値は文字列の一次元配列となる" do
            ret = Memo::Mapper.new(@test_repo).grouped_ls_to_view

            actual = ret.all?(String)

            _(actual).must_equal(true)
          end
        end

        describe "戻り値の値検査" do
          it "色付けされたディレクトリ名とそれに紐付くファイル名の配列を返す" do
            actual = Memo::Mapper.new(@test_repo).grouped_ls_to_view

            expected = @test_repo.grouped_ls.inject([]) do |result, (dir, seeds)|
              result << Rainbow(dir).green
              filename_to_view = seeds.map(&:basename).join(Memo::Mapper::INDENT)
              result << filename_to_view
            end

            _(actual).must_equal(expected)
          end
        end
      end

      describe "引数にディレクトリ名を取り、その引数に紐付くキーが存在する場合" do
        describe "戻り値の型検査" do
          it "戻り値は文字列の一次元配列となる" do
            target_dir = "cli"
            actual = Memo::Mapper.new(@test_repo).grouped_ls_to_view(target_dir)

            _(actual).must_be_instance_of(Array)
          end
        end

        describe "戻り値の値検査" do
          it "色付けされたディレクトリ名とそれに紐付くファイル名の配列を返す" do
            target_dir = "cli"
            actual = Memo::Mapper.new(@test_repo).grouped_ls_to_view(target_dir)

            _(actual).must_be_instance_of(Array)
          end
        end
      end

      describe "与えられた引数に紐付くキーが存在しない場合" do
        it "そのようなディレクトリが存在しないというメッセージを表示させる" do
          target_dir = "not_exist_dir"
          actual = Memo::Mapper.new(@test_repo).grouped_ls_to_view(target_dir)

          expected = Memo::Message::NO_DIRECTORIES.sub('dir', target_dir) << @test_repo.dir_set.join(' ')

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#dirs_to_view' do
      it "戻り値は文字列型となり、モックデータと値が同じであることを確かめる" do
        actual = Memo::Mapper.new(@test_repo).dirs_to_view
        expected = @test_repo.dir_set.join(Memo::Mapper::INDENT)

        _(actual).must_be_instance_of(String)
        _(actual).must_equal(expected)
      end
    end

    describe '#tag_list_to_view' do
      describe "戻り値の型検査" do
        it "戻り値は文字列型となる" do
          actual = Memo::Mapper.new(@test_repo).tag_list_to_view

          _(actual).must_be_instance_of(String)
        end
      end

      describe "戻り値の値検査" do
        it "タグ名の一覧を文字列として返す" do
          actual = Memo::Mapper.new(@test_repo).tag_list_to_view

          expected = @test_repo.tag_list.join("\n")

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#tag_and_filenames_to_view' do
      describe "戻り値の型検査" do
        it "戻り値は文字列の一次元配列となる" do
          ret = Memo::Mapper.new(@test_repo).tag_and_filenames_to_view

          actual = ret.all?(String)

          _(actual).must_equal(true)
        end
      end

      describe "戻り値の値検査" do
        it "色付けされたタグ名とそれに紐付くファイル名の配列を返す" do
          actual = Memo::Mapper.new(@test_repo).tag_and_filenames_to_view

          expected = @test_repo.tag_seeds_hash.inject([]) do |result, (tag, seeds)|
            result << Rainbow(tag).aqua
            filename_to_view = seeds.map(&:basename).join(Memo::Mapper::INDENT)
            result << filename_to_view
          end

          _(actual).must_equal(expected)
        end
      end
    end

    describe '#search_result_to_view' do
      describe '戻り値の型検査' do
        it '色付きの検索結果が含まれている文字列の一次元配列を返す' do
          search_word = @fixed_search_word
          result = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)

          expected = result.all? do |memo|
            memo.instance_of?(String)
            memo.include?(Rainbow(search_word).red)
          end

          _(true).must_equal(expected)
        end

        it '検索結果がなかった場合は、文字列を返す' do
          search_word = 'hikkakaranasounakotoba'
          mapper = Memo::Mapper.new(@test_repo)

          actual = mapper.search_result_to_view(search_word)

          expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word)

          _(actual).must_equal(expected)
        end
      end

      describe '戻り値の値検査' do
        it '検索でヒットした文字列に色を付けて値を返す' do
          search_word = @fixed_search_word
          expected = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)

          actual = @test_repo.search_all(search_word).flatten.map do |line|
            line.to_view(search_word)
          end

          _(actual).must_equal(expected)
        end

        it '検索結果がなかった場合は、その旨を知らせる文字列を返す' do
          search_word = 'hikkakaranasounakotoba'
          expected = Memo::Mapper.new(@test_repo).search_result_to_view(search_word)
          actual = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word)

          _(actual).must_equal(expected)
        end
      end
    end
  end
end
