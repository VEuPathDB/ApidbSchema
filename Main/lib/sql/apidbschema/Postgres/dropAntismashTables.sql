DROP TABLE ApiDB.antiSmashClutser;
DROP SEQUENCE ApiDB.antiSmashClutser_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('antiSmashClutser')
  AND database_id = (SELECT database_id
                      FROM core.DatabaseInfo
                      WHERE lower(name) = 'apidb');

------------------------------------------------------
 
DROP TABLE ApiDB.antiSmashFeatures;
DROP SEQUENCE ApiDB.antiSmashFeatures_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('antiSmashFeatures')
  AND database_id = (SELECT database_id
                      FROM core.DatabaseInfo
                      WHERE lower(name) = 'apidb');
