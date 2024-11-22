DROP TABLE ApiDB.AASequenceEpitope;
DROP SEQUENCE ApiDB.AASequenceEpitope_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('AASequenceEpitope')
  AND database_id = (SELECT database_id
                     FROM core.DatabaseInfo
                     WHERE lower(name) = 'apidb');


