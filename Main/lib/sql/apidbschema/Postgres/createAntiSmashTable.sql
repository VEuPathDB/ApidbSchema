----- Create a table for the antiSMASH clusters -----------------------
CREATE TABLE ApiDB.antiSmashCluster (
   antismash_cluster_id        	 NUMERIC(10),
   cluster_name			 VARCHAR(100),
   cluster_start                 NUMERIC(10),
   cluster_end                   NUMERIC(10),
   category                      VARCHAR(100),
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
   PRIMARY KEY (antismash_cluster_id)
 );
 
 
 CREATE SEQUENCE ApiDB.antiSmashCluster_sq;
 
 GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.antiSmashCluster TO gus_w;
 GRANT SELECT ON ApiDB.antiSmashCluster TO gus_r;
 GRANT SELECT ON ApiDB.antiSmashCluster_sq TO gus_w;
 
 INSERT INTO core.TableInfo
   (table_id, name, table_type, primary_key_column, database_id,
     is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
     modification_date, user_read, user_write, group_read, group_write,
     other_read, other_write, row_user_id, row_group_id, row_project_id,
     row_alg_invocation_id)
   SELECT NEXTVAL('core.tableinfo_sq'), 'antiSmashCluster', 'Standard', 'antiSmashCluster_id',
     d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
   FROM
        (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
        (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
   WHERE 'antiSmashCluster' NOT IN (SELECT name FROM core.TableInfo
   WHERE database_id = d.database_id);

------------------------------------------------------------------

---- Create a table for antiSmash Features -----------------------

------------------------------------------------------------------
CREATE TABLE ApiDB.antiSmashFeatures (
   antismash_feature_id          NUMERIC(10),
   na_feature_id                 VARCHAR(100),
   antiSmash_annotation          VARCHAR(100),
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
   PRIMARY KEY (antismash_feature_id),
   FOREIGN KEY (na_feature_id) REFERENCES dots.nafeature (na_feature_id)
 );
 
 
 CREATE SEQUENCE ApiDB.antiSmashFeatures_sq;
 
 GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.antiSmashFeatures TO gus_w;
 GRANT SELECT ON ApiDB.antiSmashFeatures TO gus_r;
 GRANT SELECT ON ApiDB.antiSmashFeatures_sq TO gus_w;
 
 INSERT INTO core.TableInfo
   (table_id, name, table_type, primary_key_column, database_id,
     is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
     modification_date, user_read, user_write, group_read, group_write,
     other_read, other_write, row_user_id, row_group_id, row_project_id,
     row_alg_invocation_id)
   SELECT NEXTVAL('core.tableinfo_sq'), 'antiSmashFeatures', 'Standard', 'antiSmashFeatures_id',
     d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
   FROM
        (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
        (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
   WHERE 'antiSmashFeatures' NOT IN (SELECT name FROM core.TableInfo
   WHERE database_id = d.database_id)


----------------- Liking table -----------------------------------------------------------
CREATE TABLE ApiDB.AntismashClusterFeature (
    antismash_cluster_feature_id  NUMERIC(10),
    antismash_feature_id	  NUMERIC(10),
    antismash_cluster_id          NUMERIC(10),
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
    PRIMARY KEY (antismash_cluster_feature_id),
    FOREIGN KEY (antismash_feature_id) REFERENCES ApiDB.antiSmashFeatures (antismash_feature_id),
    FOREIGN KEY (antismash_cluster_id) REFERENCES ApiDB.antiSmashClutser (antismash_cluster_id)
  );
  
 
  CREATE SEQUENCE ApiDB.AntismashClusterFeature_sq;
  
  GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.AntismashClusterFeature TO gus_w;
  GRANT SELECT ON ApiDB.AntismashClusterFeature TO gus_r;
  GRANT SELECT ON ApiDB.AntismashClusterFeature_sq TO gus_w;

  INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id,
      is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
      modification_date, user_read, user_write, group_read, group_write,
      other_read, other_write, row_user_id, row_group_id, row_project_id,
      row_alg_invocation_id)
    SELECT NEXTVAL('core.tableinfo_sq'), 'AntismashClusterFeature', 'Standard', 'AntismashClusterFeature_id',
      d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
    FROM
         (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
         (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
    WHERE 'AntismashClusterFeature' NOT IN (SELECT name FROM core.TableInfo
    WHERE database_id = d.database_id)
