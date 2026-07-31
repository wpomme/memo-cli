# frozen_string_literal: true

require_relative "../helper"

class TestEnv < Minitest::Test
  describe 'Env' do
    include MemoTestRuntimeEnvHooks

    describe '#memo_dir' do
      it 'MEMO_CLI_RUNTIME_ENVの値が未設定の場合は、例外を送出する' do
        ENV.delete('MEMO_CLI_RUNTIME_ENV')

        assert_raises(KeyError) do
          Memo::Env.memo_dir(@test_memo_dir)
        end
      end

      it 'テスト環境のときに、memo_dirにテスト用のmemo_dirを渡すと、tmpで作成されたディレクトリになる' do
        ENV['MEMO_CLI_RUNTIME_ENV'] = 'test'

        expected = @test_memo_dir
        actual = Memo::Env.memo_dir(@test_memo_dir)

        _(expected).must_equal(actual)
      end

      it 'テスト環境以外の場合は、Memo::Env::MEMO_DIRとホームディレクトリを結合したディレクトリとなる' do
        ENV['MEMO_CLI_RUNTIME_ENV'] = 'exe'

        expected = File.join(Dir.home, Memo::Env::MEMO_DIR)
        actual = Memo::Env.memo_dir

        _(actual).must_equal(expected)
      end
    end
  end
end
