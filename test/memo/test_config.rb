# frozen_string_literal: true

require_relative "../helper"

class TestConfig < Minitest::Test
  describe 'Config' do
    describe '#load' do
      it '設定ファイルが見つからない場合は、例外を送出して終了する' do
        _ do
          does_not_exist_config_path = File.expand_path("../../config/does_not_exist_config.yml", __dir__)

          load_method = Memo::Config.method(:load)
          load_method.call(does_not_exist_config_path)
        end.must_raise(Errno::ENOENT)
      end
    end

    describe '#memo_dir' do
      def setup
        @original_runtime_env = ENV.fetch('MEMO_CLI_RUNTIME_ENV', nil)
      end

      def teardown
        if @original_runtime_env.nil?
          ENV.delete('MEMO_CLI_RUNTIME_ENV')
        else
          ENV['MEMO_CLI_RUNTIME_ENV'] = @original_runtime_env
        end
      end

      it '#memo_dirがディレクトリであること' do
        ENV['MEMO_CLI_RUNTIME_ENV'] = 'exe'

        test_memo_dir = Memo::Config.memo_dir

        _(FileTest.directory?(test_memo_dir)).must_equal(true)
      end
    end
  end
end
