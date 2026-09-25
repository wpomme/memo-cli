# frozen_string_literal: true

require_relative "../helper"

class TestMapper < Minitest::Test
  describe 'Mapper' do
    include MemoTestLifecycleHooks

    describe '#file_list_to_view' do
      it "グループ化されたファイル名の一覧をViewで表示しやすくする" do
        expected = Memo::Mapper.new(@test_repo).file_list_to_view

        actual = @test_repo.grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green] + struct[:filenames]
          end

        _(actual).must_equal(expected)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'
        expected = Memo::Mapper.new(@test_repo).file_list_to_view(valid_dir)

        actual = @test_repo.grouped_file_list
          .filter_map do |struct|
            [Rainbow(struct[:dir]).green] + struct[:filenames] if struct[:dir] == valid_dir
          end

        _(actual).must_equal(expected)
      end

      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'
        mapper = Memo::Mapper.new(@test_repo)
        expected = mapper.file_list_to_view(invalid_dir)
        actual = Memo::Message::NO_DIRECTORIES.sub('dir', invalid_dir) << mapper.colored_dirs.join(' ')

        _(actual).must_equal(expected)
      end
    end

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
              result.concat(seeds.map(&:basename))
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

    describe "#file_list_hash_to_view" do
      describe "引数を取らない場合" do
        describe "戻り値の型検査" do
          it "戻り値は文字列の一次元配列となる" do
            ret = Memo::Mapper.new(@test_repo).file_list_hash_to_view

            actual = ret.all?(String)

            _(actual).must_equal(true)
          end
        end

        describe "戻り値の値検査" do
          it "色付けされたディレクトリとそれに紐付くファイル名の配列を返す" do
            actual = Memo::Mapper.new(@test_repo).file_list_hash_to_view

            expected = @test_repo.grouped_file_list_hash.inject([]) do |result, (dir, filenames)|
              result << Rainbow(dir).green
              result.concat(filenames)
            end

            _(actual).must_equal(expected)
          end
        end
      end

      describe "引数にディレクトリ名を取り、その引数に紐付くキーが存在する場合" do
        describe "戻り値の型検査" do
          it "戻り値は文字列の一次元配列となる" do
            target_dir = "cli"
            actual = Memo::Mapper.new(@test_repo).file_list_hash_to_view(target_dir)

            _(actual).must_be_instance_of(Array)
          end
        end
        it "その引数がキーに存在するならば、そのディレクトリ名を色付けして、さらにそれに紐付くファイル名のリストを返す" do
          target_dir = "cli"
          actual = Memo::Mapper.new(@test_repo).file_list_hash_to_view(target_dir)

          expected = @test_repo.grouped_file_list_hash[target_dir].map do |filename|
            (ret ||= [Rainbow(target_dir).green]) << filename
            ret
          end

          _(actual).must_equal(expected)
        end

        it "メモの中に存在しないディレクトリ名を受け取った場合は、その旨をユーザーに表示するメッセージを返す" do
          target_dir = "not_exist_dir"
          actual = Memo::Mapper.new(@test_repo).file_list_hash_to_view(target_dir)

          expected = Memo::Message::NO_DIRECTORIES.sub('dir', target_dir) << @test_repo.dir_set.join(' ')

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
