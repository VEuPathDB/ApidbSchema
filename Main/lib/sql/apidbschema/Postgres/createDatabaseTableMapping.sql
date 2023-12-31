CREATE TABLE apidb.DatabaseTableMapping (
       database_table_mapping_id NUMERIC(20),
       database_orig varchar(30),
       table_name varchar(35),
       primary_key_orig NUMERIC(20),
       primary_key NUMERIC(20),
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
 PRIMARY KEY (database_table_mapping_id)  
 );


GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.DatabaseTableMapping TO gus_w;
GRANT SELECT ON ApiDB.DatabaseTableMapping TO gus_r;

CREATE INDEX db_tbl_map_idx
ON ApiDB.DatabaseTableMapping (database_orig, table_name, primary_key_orig, primary_key) ;


CREATE SEQUENCE apidb.DatabaseTableMapping_sq;

GRANT SELECT ON apidb.DATABASETABLEMAPPING_sq TO gus_r;
GRANT SELECT ON apidb.DATABASETABLEMAPPING_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'DatabaseTableMapping',
       'Standard', 'database_table_mapping_id',
       d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'databasetablemapping' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);


CREATE TABLE apidb.GlobalNaturalKey (
       global_natural_key_id NUMERIC(20),
       table_name varchar(35),
       primary_key NUMERIC(20),
       global_natural_key varchar(1000),
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
 PRIMARY KEY (global_natural_key_id)  
 );


GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.GlobalNaturalKey TO gus_w;
GRANT SELECT ON ApiDB.GlobalNaturalKey TO gus_r;

CREATE INDEX db_tbl_map_g_idx
ON ApiDB.GlobalNaturalKey (table_name, global_natural_key, primary_key) ;

CREATE SEQUENCE apidb.GlobalNaturalKey_sq;

GRANT SELECT ON apidb.GlobalNaturalKey_sq TO gus_r;
GRANT SELECT ON apidb.GlobalNaturalKey_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'GlobalNaturalKey',
       'Standard', 'global_natural_key_id',
       d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'globalnaturalkey' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

