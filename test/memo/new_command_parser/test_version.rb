# frozen_string_literal: true

class TestNewCommandParserVersion < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe 'NewCommandParser::Version' do
    def setup
      @scp = Memo::NewCommandParser::Version.new
    end

    describe '#execute' do
      it 'Memo::NewCommandParserをインクルードしていること' do
        actual = Memo::NewCommandParser::Version.include?(Memo::NewCommandParser)

        _(actual).must_equal(true)
      end

      it '引数を取らない場合は、version: nilを返すこと' do
        actual = @scp.execute

        _(actual).must_equal({ 'version' => nil })
      end

      it '引数がある場合は、エラーメッセージを表示すること' do
        actual, = capture_io do
          exception = assert_raises(SystemExit) do
            argv = 'foo'

            @scp.execute(argv: argv)
          end

          _(exception.status).must_equal(2)
        end

        expected = TOO_MANY_ARGS.gsub('CLI', 'version')

        _(actual).must_equal(expected)
      end
    end
  end
end
