-- sqlite3の使い方
--
-- データの読み込み
-- sqlite3 db/memo.db

-- テーブルの一覧を表示する
-- .table

-- CLIの出現する回数をカウントする
SELECT count(*) FROM target_files_tags
WHERE tags_id = (
  SELECT id FROM tags WHERE tag_name = 'CLI'
);

-- タグ名でグループ化し集計する(WIP)
SELECT tags_id, count(*) FROM target_files_tags GROUP BY tags_id;

SELECT tag_name FROM tags
  INNER JOIN target_files_tags
  ON tags.id = target_files_tags.tags_id;
