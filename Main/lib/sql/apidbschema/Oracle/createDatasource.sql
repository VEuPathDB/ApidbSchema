CREATE TABLE apidb.Datasource (
 data_source_id                   NUMBER(12) NOT NULL,
 name                         VARCHAR2(200) NOT NULL,
 version                      VARCHAR2(30) NOT NULL,
 is_species_scope             NUMBER(1),
 taxon_id                     NUMBER(12),
 type                         VARCHAR2(50),
 subtype                      VARCHAR2(50),
 external_database_name       VARCHAR2(200),
 modification_date            DATE NOT NULL,
 user_read                    NUMBER(1) NOT NULL,
 user_write                   NUMBER(1) NOT NULL,
 group_read                   NUMBER(1) NOT NULL,
 group_write                  NUMBER(1) NOT NULL,
 other_read                   NUMBER(1) NOT NULL,
 other_write                  NUMBER(1) NOT NULL,
 row_user_id                  NUMBER(12) NOT NULL,
 row_group_id                 NUMBER(3) NOT NULL,
 row_project_id               NUMBER(4) NOT NULL,
 row_alg_invocation_id        NUMBER(12) NOT NULL
);

ALTER TABLE apidb.Datasource
ADD CONSTRAINT datasource_pk PRIMARY KEY (data_source_id);

ALTER TABLE apidb.Datasource
ADD CONSTRAINT datasource_uniq
UNIQUE (name, row_project_id);

ALTER TABLE apidb.Datasource
ADD CONSTRAINT datasource_fk1 FOREIGN KEY (taxon_id)
REFERENCES sres.taxon (taxon_id);

CREATE INDEX apidb.ds_tax_ix
  ON apidb.Datasource (taxon_id, data_source_id) tablespace indx;

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.Datasource TO gus_w;
GRANT SELECT ON apidb.Datasource TO gus_r;

CREATE SEQUENCE apidb.Datasource_sq;

GRANT SELECT ON apidb.Datasource_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'Datasource',
       'Standard', 'data_source_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'datasource' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);


exit;
