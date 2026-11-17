# frozen_string_literal: true

class TestSubCommandParserHelp < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe 'SubCommandParser::Help' do
    def setup
      @scp = Memo::SubCommandParser::Help.new
    end

    describe '#execute' do
      it 'Memo::HelpMessageをインクルードしていること' do
        actual = Memo::SubCommandParser::Help.include?(Memo::HelpMessage)

        _(actual).must_equal(true)
      end

      it 'Memo::SubCommandParserをインクルードしていること' do
        actual = Memo::SubCommandParser::Help.include?(Memo::SubCommandParser)

        _(actual).must_equal(true)
      end

      it '引数がない場合はGENERALを表示して終了する' do
        actual, = capture_io do
          assert_raises(SystemExit) do
            @scp.execute
          end
        end

        _(actual).must_equal(GENERAL)
      end

      it 'help tagsの場合はTAGS_DETAILを表示して終了する' do
        actual, = capture_io do
          assert_raises(SystemExit) do
            @scp.execute(argv: ['tags'])
          end
        end

        _(actual).must_equal(TAGS_DETAIL)
      end

      it 'help readの場合はREAD_DETAILを表示して終了する' do
        actual, = capture_io do
          assert_raises(SystemExit) do
            @scp.execute(argv: ['read'])
          end
        end

        _(actual).must_equal(READ_DETAIL)
      end
    end
  end
end
