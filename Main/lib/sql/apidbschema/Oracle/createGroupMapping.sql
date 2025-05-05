CREATE TABLE ApiDB.GroupMapping (
  GROUP_MAPPING_ID      VARCHAR(60) NOT NULL,
  OLD_GROUP_ID          VARCHAR(60) NOT NULL,
  NEW_GROUP_ID          VARCHAR(60) NOT NULL,
  OVERLAP_COUNT         NUMERIC(10) NOT NULL,
  GROUP_SIZE            NUMERIC(10) NOT NULL,
  MODIFICATION_DATE     TIMESTAMP,
  USER_READ             NUMERIC(1),
  USER_WRITE            NUMERIC(1),
  GROUP_READ            NUMERIC(1),
  GROUP_WRITE           NUMERIC(1),
  OTHER_READ            NUMERIC(1),
  OTHER_WRITE           NUMERIC(1),
  ROW_USER_ID           NUMERIC(12),
  ROW_GROUP_ID          NUMERIC(3),
  ROW_PROJECT_ID        NUMERIC(4),
  ROW_ALG_INVOCATION_ID NUMERIC(12),
  PRIMARY KEY (GROUP_MAPPING_ID)
);

CREATE SEQUENCE ApiDB.GroupMapping_sq;

GRANT select, update, delete ON ApiDB.GroupMapping TO gus_w;
GRANT select ON ApiDB.GroupMapping TO gus_r;
GRANT select ON ApiDB.GroupMapping_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable,
     modification_date, user_read, user_write, group_read, group_write,
     other_read, other_write, row_user_id, row_group_id, row_project_id,
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'GroupMapping',
       'Standard', 'GROUP_MAPPING_ID',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'groupmapping' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    where database_id = d.database_id);
