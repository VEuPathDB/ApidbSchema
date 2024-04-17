-- deprecated; have the DBAs do this
-- CREATE USER ApidbTuning
-- IDENTIFIED BY "<password>"   -- deprecated
-- QUOTA UNLIMITED ON users 
-- QUOTA UNLIMITED ON gus
-- QUOTA UNLIMITED ON indx
-- DEFAULT TABLESPACE users
-- TEMPORARY TABLESPACE temp;

CREATE SCHEMA apidbtuning;


-- GRANT GUS_R TO ApidbTuning;
-- GRANT GUS_W TO ApidbTuning;


-- GRANT REFERENCES ON dots.GeneFeature TO ApidbTuning;
-- GRANT REFERENCES ON dots.NaFeature TO ApidbTuning;
-- GRANT REFERENCES ON dots.NaFeatureNaGene TO ApidbTuning;
-- GRANT REFERENCES ON dots.AaSequenceImp TO ApidbTuning;
-- GRANT REFERENCES ON sres.Taxon TO ApidbTuning;

-- GRANTs required for CTXSYS
-- GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to ApiDBTuning;

-- tuningManager needs there to be a index named "ApidbTuning.blastp_text_ix"
--  (because OracleText needs it)
CREATE INDEX blastp_text_ix ON core.tableinfo(superclass_table_id, table_id, database_id);


INSERT INTO core.DatabaseInfo
   (database_id, name, description, modification_date, user_read, user_write,
    group_read, group_write, other_read, other_write, row_user_id,
    row_group_id, row_project_id, row_alg_invocation_id)
SELECT NEXTVAL('core.databaseinfo_sq'), 'ApidbTuning',
       'schema for tables created by tuning manager', localtimestamp,
       1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p
WHERE lower('ApidbTuning') NOT IN (SELECT lower(name) FROM core.DatabaseInfo);
