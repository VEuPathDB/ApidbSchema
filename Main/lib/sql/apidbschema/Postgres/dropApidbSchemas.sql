DELETE FROM core.TableInfo
WHERE database_id IN (
  SELECT database_id
  FROM core.DatabaseInfo
  WHERE name IN ('hmdb','chEBI','ApidbTuning','EDA','Model','ApiDB')
);

DELETE FROM core.DatabaseInfo WHERE name IN ('hmdb','chEBI','ApidbTuning','EDA','Model','ApiDB');

