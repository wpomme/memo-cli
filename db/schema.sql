CREATE TABLE IF NOT EXISTS directories (
  id INTEGER PRIMARY KEY,
  absolute_path TEXT NOT NULL,
);

CREATE TABLE IF NOT EXISTS files (
  id INTEGER PRIMARY KEY,
  absolute_path TEXT NOT NULL,
  FOREIGN KEY (parent_directory_id) REFERENCES directories(id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  file_content TEXT NOT NULL,
);
