DROP TABLE ApiDB.PathwayRelationship;
DROP TABLE ApiDB.PathwayNode;
DROP TABLE ApiDB.Pathway;


DROP SEQUENCE ApiDB.Pathway_SEQ;
DROP SEQUENCE ApiDB.PathwayNode_SEQ;
DROP SEQUENCE ApiDB.PathwayRelationship_SEQ;

DELETE FROM core.TableInfo
WHERE lower(name) in ('pathway', 'pathwaynode', 'pathwayrelationship')
  AND database_id = (SELECT database_id
                     FROM core.DatabaseInfo
                     WHERE lower(name) = 'apidb');

exit;
