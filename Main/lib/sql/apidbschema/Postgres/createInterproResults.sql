CREATE TABLE ApiDB.InterproResults (
  INTERPRO_RESULTS_ID           NUMERIC(10) NOT NULL,
  TRANSCRIPT_SOURCE_ID	        VARCHAR(80),
  PROTEIN_SOURCE_ID		VARCHAR(60) NOT NULL,
  GENE_SOURCE_ID		VARCHAR(80),
  NCBI_TAX_ID                   NUMERIC(10) NOT NULL,
  INTERPRO_DB_NAME		VARCHAR(150) NOT NULL,
  INTERPRO_PRIMARY_ID	        VARCHAR(100),
  INTERPRO_SECONDARY_ID	        VARCHAR(200),
  INTERPRO_DESC		        VARCHAR(1600),
  INTERPRO_START_MIN	        NUMERIC(12),
  INTERPRO_END_MIN	        NUMERIC(12),
  INTERPRO_E_VALUE	        VARCHAR(9),
  INTERPRO_FAMILY_ID            VARCHAR(50),
  MODIFICATION_DATE             TIMESTAMP,
  USER_READ                     NUMERIC(1),
  USER_WRITE                    NUMERIC(1),
  GROUP_READ                    NUMERIC(1),
  GROUP_WRITE                   NUMERIC(1),
  OTHER_READ                    NUMERIC(1),
  OTHER_WRITE                   NUMERIC(1),
  ROW_USER_ID                   NUMERIC(12),
  ROW_GROUP_ID                  NUMERIC(3),
  ROW_PROJECT_ID                NUMERIC(4),
  ROW_ALG_INVOCATION_ID         NUMERIC(12),
  PRIMARY KEY (INTERPRO_RESULTS_ID)
);

CREATE SEQUENCE ApiDB.InterproResults_sq;

GRANT insert, select, update, delete ON ApiDB.InterproResults TO gus_w;
GRANT select ON ApiDB.InterproResults TO gus_r;
GRANT select ON ApiDB.InterproResults_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable,
     modification_date, user_read, user_write, group_read, group_write,
     other_read, other_write, row_user_id, row_group_id, row_project_id,
     row_alg_invocation_id)
SELECT nextval('core.tableinfo_sq'), 'InterproResults',
       'Standard', 'interpro_results_id',
       d.database_id, 0, 0, NULL, NULL, 1,localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'InterproResults' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);
