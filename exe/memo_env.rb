class MemoEnv
  # TODO: memo init でmemo フォルダを上手く配置できるようにする
  def initialize
    @memo_dir = "/repo/memorandum/memo"
  end

  def set_memo_dir
    @memo_dir
  end
end
