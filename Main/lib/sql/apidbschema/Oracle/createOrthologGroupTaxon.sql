CREATE TABLE apidb.OrthologGroupTaxon (
  ortholog_group_taxon_id NUMBER(12)   NOT NULL,
  three_letter_abbrev     VARCHAR2(20) NOT NULL,
  number_of_proteins      NUMBER(12)   NOT NULL,
  number_of_taxa          NUMBER(12)   NOT NULL,
  group_id                VARCHAR2(16) NOT NULL,
  modification_date       DATE         NOT NULL,
  user_read               NUMBER(1)    NOT NULL,
  user_write              NUMBER(1)    NOT NULL,
  group_read              NUMBER(1)    NOT NULL,
  group_write             NUMBER(1)    NOT NULL,
  other_read              NUMBER(1)    NOT NULL,
  other_write             NUMBER(1)    NOT NULL,
  row_user_id             NUMBER(12)   NOT NULL,
  row_group_id            NUMBER(3)    NOT NULL,
  row_project_id          NUMBER(4)    NOT NULL,
  row_alg_invocation_id   NUMBER(12)   NOT NULL
);

ALTER TABLE apidb.OrthologGroupTaxon
ADD CONSTRAINT ogt_pk PRIMARY KEY (ortholog_group_taxon_id);

ALTER TABLE apidb.OrthologGroupTaxon
ADD CONSTRAINT ogt_fk1 FOREIGN KEY (group_id)
REFERENCES apidb.OrthologGroup (group_id);

CREATE INDEX apidb.ogt_group_ix ON apidb.OrthologGroupTaxon (group_id, three_letter_abbrev) tablespace indx;
CREATE INDEX apidb.ogt_abbrev_ix ON apidb.OrthologGroupTaxon (three_letter_abbrev, group_id) tablespace indx;

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.OrthologGroupTaxon TO gus_w;
GRANT SELECT ON apidb.OrthologGroupTaxon TO gus_r;

------------------------------------------------------------------------------

CREATE SEQUENCE apidb.OrthologGroupTaxon_sq;

GRANT SELECT ON apidb.OrthologGroupTaxon_sq TO gus_r;
GRANT SELECT ON apidb.OrthologGroupTaxon_sq TO gus_w;

------------------------------------------------------------------------------

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable,
     modification_date, user_read, user_write, group_read, group_write,
     other_read, other_write, row_user_id, row_group_id, row_project_id,
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'OrthologGroupTaxon',
       'Standard', 'ORTHOLOG_GROUP_TAXON_ID',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'orthologgrouptaxon' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    where database_id = d.database_id);

exit;
