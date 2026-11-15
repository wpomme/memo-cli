# frozen_string_literal: true

class TestNewCommandParserDirs < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe 'NewCommandParser::Dirs' do
    def setup
      @scp = Memo::NewCommandParser::Dirs.new
    end

    describe '#execute' do
      it 'Memo::NewCommandParserをインクルードしていること' do
        actual = Memo::NewCommandParser::Dirs.include?(Memo::NewCommandParser)

        _(actual).must_equal(true)
      end

      it '引数を取らない場合は、dirs: nilを返すこと' do
        actual = @scp.execute

        _(actual).must_equal({ 'dirs' => nil })
      end

      it '引数がある場合は、エラーメッセージを表示すること' do
        actual, = capture_io do
          exception = assert_raises(SystemExit) do
            argv = 'foo'

            @scp.execute(argv: argv)
          end

          _(exception.status).must_equal(2)
        end

        expected = TOO_MANY_ARGS.gsub('CLI', 'dirs')

        _(actual).must_equal(expected)
      end
    end
  end
end
