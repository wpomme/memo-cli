# frozen_string_literal: true

class TestCommand < Minitest::Test
  describe 'Command' do
    describe '#execute' do
      it 'listを受け取ったら、Memo::View::List#executeを呼び出すこと' do
        skip 'TODO'
        mock = Minitest::Mock.new
        mock.expect(:execute, nil, [{ word: nil }])

        Memo::View::List.stub(:new, mock) do
          Memo::Command.new.execute(['list'])
        end

        mock.verify
      end
    end
  end
end
