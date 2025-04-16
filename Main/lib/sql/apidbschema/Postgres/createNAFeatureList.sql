CREATE TABLE ApiDB.NAFeatureList (
  na_feature_list_id    NUMERIC(10) NOT NULL,
  na_feature_id         NUMERIC(10) NOT NULL,
  protocol_app_node_id  NUMERIC(10) NOT NULL,
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
  FOREIGN KEY (na_feature_id) REFERENCES DoTS.NaFeatureImp(na_feature_id),
  FOREIGN KEY (protocol_app_node_id) REFERENCES Study.ProtocolAppNode(protocol_app_node_id),
  PRIMARY KEY (na_feature_list_id)
);

create index apidb.nfl_ix
  on apidb.NaFeatureList (protocol_app_node_id, na_feature_id) tablespace indx;

CREATE SEQUENCE ApiDB.NAFeatureList_sq;

GRANT insert, select, update, delete ON ApiDB.NAFeatureList TO gus_w;
GRANT select ON ApiDB.NAFeatureList TO gus_r;
GRANT select ON ApiDB.NAFeatureList_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'NAFeatureList', 'Standard', 'na_feature_list_id',
    d.database_id, 0, 0, NULL, NULL, 1,localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'NAFeatureList' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);



