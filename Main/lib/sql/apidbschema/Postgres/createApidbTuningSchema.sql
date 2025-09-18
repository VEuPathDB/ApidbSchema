-- deprecated; have the DBAs do this
-- CREATE USER ApidbTuning
-- IDENTIFIED BY "<password>"   -- deprecated
-- QUOTA UNLIMITED ON users 
-- QUOTA UNLIMITED ON gus
-- QUOTA UNLIMITED ON indx
-- DEFAULT TABLESPACE users
-- TEMPORARY TABLESPACE temp;

-- we temporarily reset to the admin user to be able to
-- create the schema with apidbtuning as the owner
RESET ROLE;

CREATE SCHEMA apidbtuning AUTHORIZATION apidbtuning;

GRANT USAGE ON SCHEMA apidbtuning TO gus_r;
GRANT USAGE, CREATE ON SCHEMA apidbtuning TO gus_w;
ALTER DEFAULT PRIVILEGES FOR ROLE apidbtuning IN SCHEMA apidbtuning GRANT SELECT ON TABLES TO gus_r;

SET ROLE gus_w; -- drop back to gus_w role;

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

-- Now that the downstream eda.StudyIdDatasetId view that depends on this is removed, we don't need to create it ahead of time anymore.
-- Commenting out instead of removing in case that's not the case.

-- CREATE TABLE apidbTuning.StudyIdDatasetId0000 (
--   study_stable_id varchar(200),
--   dataset_id      varchar(15)
-- );
--
-- -- Posgtres doesn't have synonyms. Convert them to views instead
-- -- create or replace synonym apidbTuning.StudyIdDatasetId for apidbTuning.StudyIdDatasetId0000;
-- CREATE OR REPLACE VIEW apidbtuning.studyiddatasetid AS SELECT * FROM apidbtuning.studyiddatasetid0000;

-----------------------------------