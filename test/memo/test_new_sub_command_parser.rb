# frozen_string_literal: true

# require_relative '../helper'

class TestNewSubCommandParser < Minitest::Test
  describe '#run' do
    describe '引数による分類' do
      it '引数がない場合はヘルプメッセージを表示する' do
        skip 'TODO'
      end

      describe '第一引数がサブコマンドではない場合' do
        it 'readコマンドとして解釈する' do
          skip 'TODO'

          # 次のどちらかを返す
          _(actual).must_equal({ read: 'foo' })
          _(actual).must_equal([:read, 'foo'])
        end

        it '第二引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO'
        end
      end
    end

    describe 'サブコマンドによる分類' do
      describe 'read' do
        it '存在するファイル名なら引数として解釈できる' do
          skip 'TODO'
          # FileLoaderからファイル名の一覧を取得する
          # 拡張子がつく場合や、フォルダ名がつく場合のテストも欲しい
        end

        it '第三引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO'
        end
      end

      it 'list' do
        argv = %w[list]

        actual = Memo::NewSubCommandParser.run(argv)

        _(actual).must_equal('')
      end

      it 'list -c' do
        argv = %w[list -c]

        actual = Memo::NewSubCommandParser.run(argv)

        _(actual).must_equal(%w[list c])
      end

      it 'help' do
        actual = Memo::NewSubCommandParser.run(argv)

        _(actual).must_equal([:help, ''])
      end
    end
  end
end
