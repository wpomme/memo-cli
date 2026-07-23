# frozen_string_literal: true

require_relative "../test_helper"

class TestEnv < Minitest::Test
  describe 'Env' do
    include MemoTestLifecycleHooks

    describe '#memo_dir' do
      it 'テスト環境のときに、memo_dirにテスト用のmemo_dirを渡すと、tmpで作成されたディレクトリになる' do
        expected = @memo_dir
        actual = Memo::Env.memo_dir(@memo_dir)

        _(actual).must_equal(expected)
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
