DROP TABLE ApiDB.GenePhenotype;

DROP SEQUENCE ApiDB.GenePhenotype_sq;

DELETE FROM core.TableInfo
WHERE lower(name) = lower('GenePhenotype')
  AND database_id = (SELECT database_id
                     FROM core.DatabaseInfo
                     WHERE lower(name) = 'apidb');
