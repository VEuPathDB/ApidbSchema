DROP TABLE apidb.FileAttributes;

DELETE FROM core.TableInfo
WHERE lower(name) = lower('FileAttributes')
  AND database_id = (SELECT database_id
                     FROM core.DatabaseInfo
                     WHERE lower(name) = 'apidb');
