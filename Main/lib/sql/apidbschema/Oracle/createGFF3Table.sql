------------------------------------------------------------------------------

CREATE TABLE ApiDB.GFF3 (
 gff3_feature_id       NUMBER(10),  
 na_sequence_id        NUMBER(10) not null,  
 source                VARCHAR2(50),  
 sequence_ontology_id  NUMBER(10) not null,  
 mapping_start                 NUMBER(10),
 mapping_end                   NUMBER(10),
 score                 FLOAT,
 is_reversed           NUMBER(3),
 phase                 VARCHAR2(1),
 attr                  CLOB,
 parent_attr           VARCHAR2(100),
 id_attr               VARCHAR2(100),  
 external_database_release_id NUMBER(10),
 MODIFICATION_DATE     DATE,
 USER_READ             NUMBER(1),
 USER_WRITE            NUMBER(1),
 GROUP_READ            NUMBER(1),
 GROUP_WRITE           NUMBER(1),
 OTHER_READ            NUMBER(1),
 OTHER_WRITE           NUMBER(1),
 ROW_USER_ID           NUMBER(12),
 ROW_GROUP_ID          NUMBER(3),
 ROW_PROJECT_ID        NUMBER(4),
 ROW_ALG_INVOCATION_ID NUMBER(12),
 FOREIGN KEY (na_sequence_id) REFERENCES DoTS.NaSequenceImp (na_sequence_id),
 FOREIGN KEY (sequence_ontology_id) REFERENCES Sres.OntologyTerm (ontology_term_id),
 FOREIGN KEY (external_database_release_id) REFERENCES SRes.ExternalDatabaseRelease (external_database_release_id),
 PRIMARY KEY (gff3_feature_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.GFF3 TO gus_w;
GRANT SELECT ON ApiDB.GFF3 TO gus_r;

CREATE INDEX apidb.gff3_loc_idx
ON ApiDB.GFF3 (na_sequence_id, mapping_start, mapping_end) tablespace indx;

CREATE INDEX apidb.gff3_revfk1_idx
ON ApiDB.GFF3 (sequence_ontology_id, gff3_feature_id) tablespace indx;

CREATE INDEX apidb.gff3_revfk2_idx
ON ApiDB.GFF3 (external_database_release_id, gff3_feature_id) tablespace indx;

CREATE SEQUENCE apidb.GFF3_sq;

GRANT SELECT ON apidb.GFF3_sq TO gus_r;
GRANT SELECT ON apidb.GFF3_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'GFF3',
       'Standard', 'gff3_feature_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'gff3' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

CREATE TABLE ApiDB.GFF3AttributeKey (
 gff3_attribute_key_id NUMBER(38) not null,
 name	               VARCHAR2(64) not null,
 MODIFICATION_DATE     DATE,
 USER_READ             NUMBER(1),
 USER_WRITE            NUMBER(1),
 GROUP_READ            NUMBER(1),
 GROUP_WRITE           NUMBER(1),
 OTHER_READ            NUMBER(1),
 OTHER_WRITE           NUMBER(1),
 ROW_USER_ID           NUMBER(12),
 ROW_GROUP_ID          NUMBER(3),
 ROW_PROJECT_ID        NUMBER(4),
 ROW_ALG_INVOCATION_ID NUMBER(12),
 PRIMARY KEY (gff3_attribute_key_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.GFF3AttributeKey TO gus_w;
GRANT SELECT ON ApiDB.GFF3AttributeKey TO gus_r;

CREATE SEQUENCE apidb.GFF3AttributeKey_sq;

GRANT SELECT ON apidb.GFF3AttributeKey_sq TO gus_r;
GRANT SELECT ON apidb.GFF3AttributeKey_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'GFF3AttributeKey',
       'Standard', 'gff3_attribute_key_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'gff3attributekey' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

CREATE TABLE ApiDB.GFF3Attributes (
 gff3_attribute_id     NUMBER(38) not null,
 gff3_attribute_key_id NUMBER(38) not null,
 gff3_feature_id       NUMBER(10) not null,
 value	               VARCHAR2(300) not null,
 MODIFICATION_DATE     DATE,
 USER_READ             NUMBER(1),
 USER_WRITE            NUMBER(1),
 GROUP_READ            NUMBER(1),
 GROUP_WRITE           NUMBER(1),
 OTHER_READ            NUMBER(1),
 OTHER_WRITE           NUMBER(1),
 ROW_USER_ID           NUMBER(12),
 ROW_GROUP_ID          NUMBER(3),
 ROW_PROJECT_ID        NUMBER(4),
 ROW_ALG_INVOCATION_ID NUMBER(12),
 FOREIGN KEY (gff3_attribute_key_id) REFERENCES Apidb.GFF3AttributeKey (gff3_attribute_key_id),
 FOREIGN KEY (gff3_feature_id) REFERENCES ApiDB.GFF3 (gff3_feature_id), 
 PRIMARY KEY (gff3_attribute_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON ApiDB.GFF3Attributes TO gus_w;
GRANT SELECT ON ApiDB.GFF3Attributes TO gus_r;

CREATE SEQUENCE apidb.GFF3Attributes_sq;

CREATE INDEX apidb.gff3att_revfk1_idx
ON ApiDB.GFF3Attributes (gff3_feature_id, gff3_attribute_id) tablespace indx;

CREATE INDEX apidb.gff3att_revfk2_idx
ON ApiDB.GFF3Attributes (gff3_attribute_key_id, gff3_attribute_id) tablespace indx;

GRANT SELECT ON apidb.GFF3Attributes_sq TO gus_r;
GRANT SELECT ON apidb.GFF3Attributes_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'GFF3Attributes',
       'Standard', 'gff3_attribute_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'gff3attributes' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

exit;
