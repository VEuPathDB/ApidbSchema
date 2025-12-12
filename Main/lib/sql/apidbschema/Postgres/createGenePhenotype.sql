-- for now there will be one row per gene/phenotype but leaving this as "tall" (prop+values) for possible future case
-- this is meant to supplement data in EDA tables;  long text is not handled well there
create table ApiDB.GenePhenotype (
 gene_phenotype_id              NUMERIC(10) ,
 gene_source_id                 VARCHAR(80) NOT NULL,
 phenotype_stable_id            VARCHAR(200) NOT NULL,
 property                       VARCHAR(400) NOT NULL,
 text_value                     TEXT, -- leave this as "TEXT"  as some are very long
 external_database_release_id NUMERIC(10) NOT NULL,
 modification_date              TIMESTAMP,
 user_read                      NUMERIC(1),
 user_write                     NUMERIC(1),
 group_read                     NUMERIC(1),
 group_write                    NUMERIC(1),
 other_read                     NUMERIC(1),
 other_write                    NUMERIC(1),
 row_user_id                    NUMERIC(12),
 row_group_id                   NUMERIC(3),
 row_project_id                 NUMERIC(4),
 row_alg_invocation_id          NUMERIC(12),
 FOREIGN KEY (EXTERNAL_DATABASE_RELEASE_ID) REFERENCES sres.ExternalDatabaseRelease (EXTERNAL_DATABASE_RELEASE_ID),
 PRIMARY KEY (gene_phenotype_id)
);

create index eegp_1
  on apidb.GenePhenotype (gene_source_id, phenotype_stable_id, external_database_release_id, gene_phenotype_id) ;

CREATE SEQUENCE apidb.GenePhenotype_sq;

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.GenePhenotype TO gus_w;
GRANT SELECT ON apidb.GenePhenotype TO gus_r;
GRANT SELECT ON apidb.GenePhenotype_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable,
     modification_date, user_read, user_write, group_read, group_write,
     other_read, other_write, row_user_id, row_group_id, row_project_id,
     row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'GenePhenotype',
       'Standard', 'gene_phenotype_id',
       d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM
     (SELECT MIN(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'genephenotype' NOT IN (SELECT LOWER(name) FROM core.TableInfo
                               WHERE database_id = d.database_id);
