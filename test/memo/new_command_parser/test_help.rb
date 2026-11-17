# frozen_string_literal: true

class TestNewCommandParserHelp < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe 'NewCommandParser::Help' do
    def setup
      @scp = Memo::NewCommandParser::Help.new
    end

    describe '#execute' do
      it 'Memo::HelpMessageをインクルードしていること' do
        actual = Memo::NewCommandParser::Help.include?(Memo::HelpMessage)

        _(actual).must_equal(true)
      end

      it 'Memo::NewCommandParserをインクルードしていること' do
        actual = Memo::NewCommandParser::Help.include?(Memo::NewCommandParser)

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
