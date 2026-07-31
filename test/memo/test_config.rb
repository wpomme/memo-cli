# frozen_string_literal: true

require_relative "../helper"

class TestConfig < Minitest::Test
  describe 'Config' do
    # include MemoTestRuntimeConfigHooks

    describe '#memo_dir' do
      it 'MEMO_CLI_RUNTIME_ENVの値が未設定の場合は、例外を送出する' do
        skip "TODO"
        ENV.delete('MEMO_CLI_RUNTIME_ENV')

        assert_raises(KeyError) do
          Memo::Config.memo_dir(@memo_dir)
        end
      end

      it 'テスト環境のときに、memo_dirにテスト用のmemo_dirを渡すと、tmpで作成されたディレクトリになる' do
        skip "TODO"
        ENV['MEMO_CLI_RUNTIME_ENV'] = 'test'

        expected = @memo_dir
        actual = Memo::Config.memo_dir(@memo_dir)

        _(expected).must_equal(actual)
      end

      it 'テスト環境以外の場合は、Memo::Config::MEMO_DIRとホームディレクトリを結合したディレクトリとなる' do
        skip "TODO"
        ENV['MEMO_CLI_RUNTIME_ENV'] = 'exe'

        config_path = File.expand_path("../../config/config.yml", __dir__)
        config = YAML.load_file(config_path)

        expected = File.join(Dir.home, config[memo_dir])
        actual = Memo::Config.memo_dir

        _(actual).must_equal(expected)
      end
    end
  end
end
