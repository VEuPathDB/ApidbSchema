-- deprecated; have the DBAs do this
-- CREATE USER ApidbTuning
-- IDENTIFIED BY "<password>"   -- deprecated
-- QUOTA UNLIMITED ON users 
-- QUOTA UNLIMITED ON gus
-- QUOTA UNLIMITED ON indx
-- DEFAULT TABLESPACE users
-- TEMPORARY TABLESPACE temp;

GRANT GUS_R TO ApidbTuning;
GRANT GUS_W TO ApidbTuning;
GRANT CREATE VIEW TO ApidbTuning;
GRANT CREATE MATERIALIZED VIEW TO ApidbTuning;
GRANT CREATE TABLE TO ApidbTuning;
GRANT CREATE SYNONYM TO ApidbTuning;
GRANT CREATE SESSION TO ApidbTuning;
GRANT CREATE ANY INDEX TO ApidbTuning;
GRANT CREATE TRIGGER TO ApidbTuning;
GRANT CREATE ANY TRIGGER TO ApidbTuning;

GRANT REFERENCES ON dots.GeneFeature TO ApidbTuning;
GRANT REFERENCES ON dots.NaFeature TO ApidbTuning;
GRANT REFERENCES ON dots.NaFeatureNaGene TO ApidbTuning;
GRANT REFERENCES ON dots.AaSequenceImp TO ApidbTuning;
GRANT REFERENCES ON sres.Taxon TO ApidbTuning;

-- GRANTs required for CTXSYS
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to ApiDBTuning;

-- tuningManager needs there to be a index named "ApidbTuning.blastp_text_ix"
--  (because OracleText needs it)
CREATE INDEX ApidbTuning.blastp_text_ix
ON core.tableinfo(superclass_table_id, table_id, database_id);

INSERT INTO core.DatabaseInfo
   (database_id, name, description, modification_date, user_read, user_write,
    group_read, group_write, other_read, other_write, row_user_id,
    row_group_id, row_project_id, row_alg_invocation_id)
SELECT core.databaseinfo_sq.nextval, 'ApidbTuning',
       'schema for tables created by tuning manager', sysdate,
       1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM dual, (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p
WHERE lower('ApidbTuning') NOT IN (SELECT lower(name) FROM core.DatabaseInfo);

alter user ApidbTuning quota unlimited on indx;

--------------------------------------------------------------------------------
--
-- create empty Sanger tuning tables, so they can be referenced even in
-- instances for which we don't run the Sanger feed
--
create table apidbTuning.AnnotationChange0000
 (
  gene        varchar2(60),
  mrnaid      varchar2(80),
  change      varchar2(400),
  change_date date,
  name        varchar2(60),
  product     varchar2(800)
);


grant insert, select, update, delete on apidbTuning.AnnotationChange0000 to public;

create or replace synonym apidbTuning.AnnotationChange
  for apidbTuning.AnnotationChange0000;

create table apidbTuning.ChangedGeneProduct0000
  (
   gene    varchar2(80),
   product varchar2(800),
   name    varchar2(60)
  );

grant insert, select, update, delete on apidbTuning.ChangedGeneProduct0000 to public;

create or replace synonym apidbTuning.ChangedGeneProduct
  for apidbTuning.ChangedGeneProduct0000;

--------------------------------------------------------------------------------
create table apidbTuning.StudyIdDatasetId0000 (
  study_stable_id varchar2(200),
  dataset_id      varchar2(15)
  );

grant select on apidbTuning.StudyIdDatasetId0000 to public;

create or replace synonym apidbTuning.StudyIdDatasetId for apidbTuning.StudyIdDatasetId0000;

--------------------------------------------------------------------------------

exit
