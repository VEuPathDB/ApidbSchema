drop table ApiDB.AASequenceEpitope;
drop sequence ApiDB.AASequenceEpitope_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('AASequenceEpitope')
  AND database_id = (SELECT database_id
                     FROM core.DatabaseInfo
                     WHERE lower(name) = 'apidb');


----------------------------------------------------------
drop table ApiDB.AASequenceEpitopeAccession;
drop seqeunce ApiDB.AASequenceEpitopeAccession_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('AASequenceEpitopeAccession')
  AND database_id = (SELECT database_id
                     FROM core.DatabaseInfo
                     WHERE lower(name) = 'apidb');

exit;
