CREATE TABLE ApiDB.GenomeBedGraph (
  GENOME_BED_GRAPH_ID      NUMBER(10) NOT NULL,
  SEQUENCE_SOURCE_ID       VARCHAR2(60) NOT NULL,
  START_LOCATION           NUMBER(12) NOT NULL,
  END_LOCATION             NUMBER(12) NOT NULL,
  ALGORITHM		   VARCHAR2(20) NOT NULL,
  VALUE		           VARCHAR2(20),
  EXTERNAL_DB_RELEASE_ID   NUMBER NOT NULL,
  MODIFICATION_DATE        DATE,
  USER_READ                NUMBER(1),
  USER_WRITE               NUMBER(1),
  GROUP_READ               NUMBER(1),
  GROUP_WRITE              NUMBER(1),
  OTHER_READ               NUMBER(1),
  OTHER_WRITE              NUMBER(1),
  ROW_USER_ID              NUMBER(12),
  ROW_GROUP_ID             NUMBER(3),
  ROW_PROJECT_ID           NUMBER(4),
  ROW_ALG_INVOCATION_ID    NUMBER(12),
  PRIMARY KEY (GENOME_BED_GRAPH_ID),
  FOREIGN KEY (external_db_release_id) REFERENCES sres.externaldatabaserelease(external_database_release_id)
);

CREATE SEQUENCE ApiDB.GenomeBedGraph_sq;

GRANT insert, select, update, delete ON ApiDB.GenomeBedGraph TO gus_w;
GRANT select ON ApiDB.GenomeBedGraph TO gus_r;
GRANT select ON ApiDB.GenomeBedGraph_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT core.tableinfo_sq.nextval, 'GenomeBedGraph', 'Standard', 'genome_bed_graph_id',
    d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
  FROM dual,
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'GenomeBedGraph' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);


exit;
