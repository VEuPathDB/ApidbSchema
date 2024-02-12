CREATE TABLE ApiDB.GeneCNV (
  GENE_CNV_ID               numeric(12) NOT NULL,
  PROTOCOL_APP_NODE_ID      numeric(10) NOT NULL,
  NA_SEQUENCE_ID            numeric(12) NOT NULL,
  CHR_COPY_NUMERIC          numeric(10),
  MODIFICATION_DATE         timestamp,
  USER_READ                 numeric(1),
  USER_WRITE                numeric(1),
  GROUP_READ                numeric(10),
  GROUP_WRITE               numeric(1),
  OTHER_READ                numeric(1),
  OTHER_WRITE               numeric(1),
  ROW_USER_ID               numeric(12),
  ROW_GROUP_ID              numeric(4),
  ROW_PROJECT_ID            numeric(4),
  ROW_ALG_INVOCATION_ID	    numeric(12),
  PRIMARY KEY (GENE_CNV_ID),
  FOREIGN KEY (PROTOCOL_APP_NODE_ID) REFERENCES Study.ProtocolAppNode (PROTOCOL_APP_NODE_ID),
  FOREIGN KEY (NA_SEQUENCE_ID) REFERENCES DoTS.NASequenceImp (NA_SEQUENCE_ID)
);

CREATE INDEX apidb.gcnv_revix1 ON apidb.GeneCNV (na_sequence_id, gene_cnv_id) TABLESPACE indx;
CREATE INDEX apidb.gcnv_revix0 ON apidb.GeneCNV (protocol_app_node_id, gene_cnv_id) TABLESPACE indx;

CREATE SEQUENCE ApiDB.GeneCNV_SQ;

GRANT SELECT ON ApiDB.GeneCNV TO gus_r;
GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.GeneCNV TO gus_w;

GRANT SELECT ON ApiDB.GeneCNV_SQ TO gus_r;
GRANT SELECT ON ApiDB.GeneCNV_SQ TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'GeneCNV', 'Standard', 'GENE_CNV_ID',
    d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
    p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'GeneCNV' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);

CREATE TABLE ApiDB.Ploidy (
  PLOIDY_ID                 numeric(12)  NOT NULL,
  PROTOCOL_APP_NODE_ID      numeric(10)  NOT NULL,
  NA_FEATURE_ID 	    numeric(12)  NOT NULL,
  HAPLOID_NUMERIC 	    FLOAT(126),
  REF_COPY_NUMERIC          numeric(10),
  MODIFICATION_DATE         timestamp,
  USER_READ                 numeric(1),
  USER_WRITE                numeric(1),
  GROUP_READ                numeric(1),
  GROUP_WRITE               numeric(1),
  OTHER_READ                numeric(1),
  OTHER_WRITE               numeric(1),
  ROW_USER_ID               numeric(12),
  ROW_GROUP_ID              numeric(3),
  ROW_PROJECT_ID            numeric(4),
  ROW_ALG_INVOCATION_ID     numeric(12),
  PRIMARY KEY (PLOIDY_ID),
  FOREIGN KEY (PROTOCOL_APP_NODE_ID) REFERENCES Study.ProtocolAppNode (PROTOCOL_APP_NODE_ID),
  FOREIGN KEY (NA_FEATURE_ID) REFERENCES DoTS.NAFeatureImp (NA_FEATURE_ID)
);

CREATE INDEX apidb.pldy_revix0 ON apidb.Ploidy (na_feature_id, ploidy_id) TABLESPACE indx;
CREATE INDEX apidb.pldy_revix1 ON apidb.Ploidy (PROTOCOL_APP_NODE_ID, PLOIDY_ID) tablespace indx;

CREATE SEQUENCE ApiDB.Ploidy_SQ;


GRANT SELECT ON ApiDB.Ploidy TO gus_r;
GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.Ploidy TO gus_w;

GRANT SELECT ON ApiDB.Ploidy_SQ TO gus_r;
GRANT SELECT ON ApiDB.Ploidy_SQ TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'Ploidy', 'Standard', 'PLOIDY_ID',
    d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
    p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'Ploidy' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);

exit;
