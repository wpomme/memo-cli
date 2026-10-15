-- sqlite3の使い方
--
-- データの読み込み
-- sqlite3 db/memo.db

-- テーブルの一覧を表示する
-- .table

-- CLIの出現する回数をカウントする
SELECT count(*) FROM files_tags
WHERE tags_id = (
  SELECT id FROM tags WHERE tag_name = 'CLI'
);

-- タグ名と、そのタグがファイルに紐づけられている数を降順で出力する
SELECT tag_name, count(*) AS tag_count FROM tags
  INNER JOIN files_tags
     ON tags.id = files_tags.tags_id
  GROUP BY tag_name
  ORDER BY tag_count DESC;

-- タグ名と、そのタグが付いているファイル名の一覧を返す
SELECT T.tag_name, F.absolute_path FROM tags AS T
  INNER JOIN files_tags AS FT
     ON T.id = FT.tags_id
  INNER JOIN files AS F
     ON F.id = FT.files_id;

-- 設定ディレクトリテーブルとディレクトリテーブルを結合させて、絶対パスを返す
SELECT CD.directory_path || D.directory_path AS absolute_path FROM config_directories AS CD
  INNER JOIN directories AS D
     ON CD.id = D.config_directory_id;
