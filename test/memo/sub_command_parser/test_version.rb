# frozen_string_literal: true

require_relative '../../helper'

class TestSubCommandParserVersion < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe 'SubCommandParser::Version' do
    def setup
      @scp = Memo::SubCommandParser::Version.new
    end

    describe '#execute' do
      it 'Memo::SubCommandParserをインクルードしていること' do
        actual = Memo::SubCommandParser::Version.include?(Memo::SubCommandParser)

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
