# frozen_string_literal: true

require_relative "../helper"

class TestMapper < Minitest::Test
  describe 'Mapper::@memo_dir' do
    include MemoTestRuntimeEnvHooks

    describe '@memo_dir' do
      it 'テスト環境のときに、memo_dirにテスト用のmemo_dirを渡すと、tmpで作成されたディレクトリになる' do
        mapper = Memo::Mapper.new(@memo_dir)
        expected = mapper.instance_variable_get(:@memo_dir)
        actual = @memo_dir

        _(actual).must_equal(expected)
      end

      it 'テスト環境以外の場合は、Memo::Env::MEMO_DIRとホームディレクトリを結合したディレクトリとなる' do
        ENV['MEMO_CLI_RUNTIME_ENV'] = 'exe'

        mapper = Memo::Mapper.new(Memo::Env.memo_dir)
        expected = mapper.instance_variable_get(:@memo_dir)
        actual = File.join(Dir.home, Memo::Env::MEMO_DIR)

        _(actual).must_equal(expected)
      end
    end
  end

  describe 'Mapper' do
    include MemoTestLifecycleHooks

    describe '#file_list_to_view' do
      it "グループ化されたファイル名の一覧をViewで表示しやすくする" do
        expected = Memo::Mapper.new(@memo_dir).file_list_to_view

        grouped_file_list = Memo::Model.new.grouped_file_list(@test_seeds)

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end.flatten

        actual.pop

        _(actual).must_equal(expected)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'
        expected = Memo::Mapper.new(@memo_dir).file_list_to_view(valid_dir)

        grouped_file_list_by_dir = @test_seeds.group_by(&:dir).filter_map do |dir, seed|
          if dir == valid_dir
            Memo::Model::GroupedFileList.new(
              dir: dir,
              filenames: seed.map(&:filename).sort
            )
          end
        end

        actual = grouped_file_list_by_dir
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end.flatten

        actual.pop

        _(actual).must_equal(expected)
      end

      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'
        expected = Memo::Mapper.new(@memo_dir).file_list_to_view(invalid_dir)

        # TODO: とりあえず文字列を返すことだけを確認する
        assert expected.is_a?(String)
      end
    end
  end
end
