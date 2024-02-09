CREATE TABLE apidb.DatabaseTableMapping (
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
       ROW_ALG_INVOCATION_ID NUMERIC(12)
 );


GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.DatabaseTableMapping TO gus_w;
GRANT SELECT ON ApiDB.DatabaseTableMapping TO gus_r;

CREATE INDEX db_tbl_map_idx
ON ApiDB.DatabaseTableMapping (database_orig, table_name, primary_key_orig, primary_key) ;


CREATE TABLE apidb.GlobalNaturalKey (
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
       ROW_ALG_INVOCATION_ID NUMERIC(12)
 );


GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.GlobalNaturalKey TO gus_w;
GRANT SELECT ON ApiDB.GlobalNaturalKey TO gus_r;

CREATE INDEX db_tbl_map_g_idx
ON ApiDB.GlobalNaturalKey (table_name, global_natural_key, primary_key) ;
