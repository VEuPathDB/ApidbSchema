-- deprecated; have the DBAs do this
-- CREATE USER ApiDB
-- IDENTIFIED BY "<password>"
-- QUOTA UNLIMITED ON users 
-- QUOTA UNLIMITED ON gus
-- QUOTA UNLIMITED ON indx
-- DEFAULT TABLESPACE users
-- TEMPORARY TABLESPACE temp;

CREATE SCHEMA apidb;

GRANT USAGE ON SCHEMA apidb TO gus_r;

-- GRANT GUS_R TO ApiDB;
-- GRANT GUS_W TO ApiDB;
-- GRANT CREATE VIEW TO ApiDB;
-- GRANT CREATE MATERIALIZED VIEW TO ApiDB;
-- GRANT CREATE TABLE TO ApiDB;
-- GRANT CREATE SYNONYM TO ApiDB;
-- GRANT CREATE SESSION TO ApiDB;
-- GRANT CREATE ANY INDEX TO ApiDB;
-- GRANT CREATE TRIGGER TO ApiDB;
-- GRANT CREATE ANY TRIGGER TO ApiDB;
--
-- GRANT REFERENCES ON core.AlgorithmInvocation TO ApiDB;
-- GRANT REFERENCES ON core.TableInfo to ApiDB;
--
-- GRANT REFERENCES ON dots.AaSequenceImp TO ApiDB;
-- GRANT REFERENCES ON dots.AaSeqGroupExperimentImp TO ApiDB;
-- GRANT REFERENCES ON dots.BlatAlignmentQuality TO ApiDB;
-- GRANT REFERENCES ON dots.ChromosomeElementFeature TO ApiDB;
-- GRANT REFERENCES ON dots.GeneFeature TO ApiDB;
-- GRANT references ON dots.NaFeatureImp TO apidb;
-- GRANT REFERENCES ON dots.NaFeatureNaGene TO ApiDB;
-- GRANT REFERENCES ON dots.NaFeature TO ApiDB;
-- GRANT REFERENCES ON dots.NaSequenceImp TO ApiDB;
-- GRANT REFERENCES ON dots.NaSequence TO ApiDB;
--
-- GRANT REFERENCES ON sres.DbRef TO ApiDB;
-- GRANT REFERENCES ON sres.ExternalDatabaseRelease to ApiDB;
-- GRANT REFERENCES ON sres.PathwayRelationship TO ApiDB;
-- GRANT REFERENCES ON sres.Pathway TO ApiDB;
-- GRANT REFERENCES ON sres.Taxon TO ApiDB;
-- GRANT REFERENCES ON sres.OntologyTerm TO ApiDB;
-- GRANT REFERENCES ON sres.ExternalDatabase TO apidb;
--
-- GRANT REFERENCES ON study.ProtocolAppNode TO ApiDB;

-- must be GRANTed directly (not just through a role such as GUS_R) for use in PL/SQL functions
-- TODO check if that's the case for postgres. apidb is a schema not a user/role so need to deal with it otherwise
-- GRANT SELECT ON core.ProjectInfo to ApiDB;
-- GRANT SELECT ON sres.TaxonName to ApiDB;
-- GRANT SELECT ON sres.Taxon to ApiDB;
GRANT SELECT, DELETE ON dots.NaFeatureImp TO PUBLIC;

INSERT INTO core.DatabaseInfo
   (database_id, name, description, modification_date, user_read, user_write,
    group_read, group_write, other_read, other_write, row_user_id,
    row_group_id, row_project_id, row_alg_invocation_id)
SELECT NEXTVAL('core.databaseinfo_sq'), 'ApiDB',
       'Application-specific data for the ApiDB websites', localtimestamp,
       1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p
WHERE lower('ApiDB') NOT IN (SELECT lower(name) FROM core.DatabaseInfo);

-- GRANTs required for CTXSYS
-- GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to apidb;

-- alter user ApiDB quota unlimited on indx;
