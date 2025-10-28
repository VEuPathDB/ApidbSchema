DROP TABLE ApiDB.antiSmashCluster;
DROP SEQUENCE ApiDB.antiSmashCluster_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('antiSmashCluster')
  AND database_id = (SELECT database_id
                      FROM core.DatabaseInfo
                      WHERE lower(name) = 'apidb');

------------------------------------------------------
 
DROP TABLE ApiDB.antiSmashFeature;
DROP SEQUENCE ApiDB.antiSmashFeature_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('antiSmashFeature')
  AND database_id = (SELECT database_id
                      FROM core.DatabaseInfo
                      WHERE lower(name) = 'apidb');

------------------------------------------------------

DROP TABLE ApiDB.antiSmashClusterFeature;
DROP SEQUENCE ApiDB.antiSmashClusterFeature_sq;
DELETE FROM core.TableInfo
WHERE lower(name) = lower('antiSmashClusterFeature')
  AND database_id = (SELECT database_id
                      FROM core.DatabaseInfo
                      WHERE lower(name) = 'apidb');
