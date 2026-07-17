# frozen_string_literal: true

require_relative "../test_helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    ###
    # テストデータだとDocsの方でデータを作成してしまうため、テストに失敗してしまう。
    # 1c1
    # <  #<data Memo::Docs::Entry full_path="/var/folders/lg/wtp42wtx66nf0d87br2jwzf00000gn/T/d20260718-56814-5cqnm3/memo/cli/find.md"
    # ---
    # >  #<data Memo::Repository::Entry full_path="/var/folders/lg/wtp42wtx66nf0d87br2jwzf00000gn/T/d20260718-56814-5cqnm3/memo/cli/find.md"
    describe '#initialize' do
      it 'Repository.new()は、ハッシュの配列を返す' do
        expected = Memo::Repository.new(@memo_dir).to_set

        _(expected).must_equal(@test_repository_entries.to_set)
      end
    end
  end
end
