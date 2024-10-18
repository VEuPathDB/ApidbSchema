CREATE TABLE ApiDB.ProteinBedGraph (
  PROTEIN_BED_GRAPH_ID      NUMERIC(10) NOT NULL,
  SEQUENCE_SOURCE_ID       VARCHAR(60) NOT NULL,
  START_LOCATION           NUMERIC(12) NOT NULL,
  END_LOCATION             NUMERIC(12) NOT NULL,
  ALGORITHM		   VARCHAR(20) NOT NULL,
  VALUE		           VARCHAR(20),
  EXTERNAL_DB_RELEASE_ID   NUMERIC NOT NULL,
  MODIFICATION_DATE        TIMESTAMP,
  USER_READ                NUMERIC(1),
  USER_WRITE               NUMERIC(1),
  GROUP_READ               NUMERIC(1),
  GROUP_WRITE              NUMERIC(1),
  OTHER_READ               NUMERIC(1),
  OTHER_WRITE              NUMERIC(1),
  ROW_USER_ID              NUMERIC(12),
  ROW_GROUP_ID             NUMERIC(3),
  ROW_PROJECT_ID           NUMERIC(4),
  ROW_ALG_INVOCATION_ID    NUMERIC(12),
  PRIMARY KEY (PROTEIN_BED_GRAPH_ID),
  FOREIGN KEY (external_db_release_id) REFERENCES sres.externaldatabaserelease(external_database_release_id)
);

CREATE SEQUENCE ApiDB.ProteinBedGraph_sq;

GRANT insert, select, update, delete ON ApiDB.ProteinBedGraph TO gus_w;
GRANT select ON ApiDB.ProteinBedGraph TO gus_r;
GRANT select ON ApiDB.ProteinBedGraph_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT core.tableinfo_sq.nextval, 'ProteinBedGraph', 'Standard', 'protein_bed_graph_id',
    d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
  FROM dual,
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'ProteinBedGraph' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);


exit;
