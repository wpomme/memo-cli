# メモフォルダへの絶対パスを返す
dir = Memo::Env.to_memo_dir

# Entryの配列を取得
# Memo::から始まるから見づらい
entries = Memo::Repository.new(dir)

# ディレクトリをキーとして、そのディレクトリに所属するファイルのEntryを保存する
# MemoFileUtility::grouped_by_dir と同じ実装
entries.group_by(&:dir)

# データ構造はHashである
entries.group_by(&:dir).is_a?(Hash)
# -> Hash

# 全てのフルパスを取得
entries.map(&:full_path)

# ファイル名だけ取得(Entryの:filenameを使えば取得できるか...)
entries.map(&:full_path).map{|path| File.basename(path, '.md')}

# ソートしたら、重複している項目が目視で分かる
full_paths.sort

# メモ内のファイルを全文表示する
# irbだと表示されない
# full_paths.each do |full_path|
#   File.readlines(full_path, chomp: true)
# end

