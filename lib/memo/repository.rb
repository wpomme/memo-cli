# frozen_string_literal: true

module Memo
  class Repository
    include Enumerable
    include MemoFileUtility

    EXCLUDE_FILES = ['README.md'].to_set.freeze

    Entry = Data.define(:full_path, :filename, :dir)

    def initialize(memo_dir)
      @entries = load(memo_dir)
    end

    def each(&)
      @entries.each(&)
    end

    private

    def load(memo_dir)
      Dir.glob("**/*.md", base: memo_dir).filter_map do |rel_path|
        # README.mdは読み飛ばす
        next if EXCLUDE_FILES.include?(File.basename(rel_path))

        full_path = File.join(memo_dir, rel_path)

        # トップディレクトリにあるメモのdirは"."となってしまうため、引数として受け取ったディレクトリの末尾を使う
        dir = File.dirname(rel_path) == "." ? File.basename(memo_dir) : File.dirname(rel_path)

        Entry.new(
          full_path: full_path,
          filename: filename(full_path),
          dir: dir
        )
      end
    end
  end
end
