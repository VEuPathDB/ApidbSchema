CREATE TABLE ApiDB.Indel (
  INDEL_ID                     NUMERIC(10)  NOT NULL,
  PROTOCOL_APP_NODE_ID         NUMERIC(10)  NOT NULL,
  SAMPLE_NAME                  VARCHAR(100) NOT NULL,
  NA_SEQUENCE_ID	       NUMERIC(10)  NOT NULL,
  LOCATION		       NUMERIC(15)  NOT NULL,
  SHIFT			       NUMERIC(5)   NOT NULL,
  MODIFICATION_DATE            TIMESTAMP,
  USER_READ                    NUMERIC(1),
  USER_WRITE                   NUMERIC(1),
  GROUP_READ                   NUMERIC(1),
  GROUP_WRITE                  NUMERIC(1),
  OTHER_READ                   NUMERIC(1),
  OTHER_WRITE                  NUMERIC(1),
  ROW_USER_ID                  NUMERIC(12),
  ROW_GROUP_ID                 NUMERIC(3),
  ROW_PROJECT_ID               NUMERIC(4),
  ROW_ALG_INVOCATION_ID        NUMERIC(12),
  PRIMARY KEY (INDEL_ID),
  FOREIGN KEY (NA_SEQUENCE_ID) REFERENCES dots.nasequenceimp (NA_SEQUENCE_ID),
  FOREIGN KEY (PROTOCOL_APP_NODE_ID) REFERENCES Study.ProtocolAppNode (PROTOCOL_APP_NODE_ID)
);

CREATE INDEX apidb.indel_0 ON apidb.Indel (na_sequence_id, indel_id) TABLESPACE indx;
CREATE INDEX apidb.indel_1 ON apidb.Indel (protocol_app_node_id, indel_id) TABLESPACE indx;

CREATE SEQUENCE ApiDB.Indel_sq;

GRANT insert, select, update, delete ON ApiDB.Indel TO gus_w;
GRANT select ON ApiDB.Indel TO gus_r;
GRANT select ON ApiDB.Indel_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'Indel', 'Standard', 'indel_id',
    d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
    p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'Indel' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);

exit;
