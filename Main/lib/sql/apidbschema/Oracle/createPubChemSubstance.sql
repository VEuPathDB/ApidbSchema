CREATE TABLE apidb.PubChemSubstance (
 	pubchem_substance_id    NUMBER(10),
 	substance_id            NUMBER(10) NOT NULL,
 	compound_id             NUMBER(10),
 	MODIFICATION_DATE       DATE,
 	USER_READ               NUMBER(1),
 	USER_WRITE              NUMBER(1),
 	GROUP_READ              NUMBER(1),
 	GROUP_WRITE             NUMBER(1),
 	OTHER_READ              NUMBER(1),
 	OTHER_WRITE             NUMBER(1),
 	ROW_USER_ID             NUMBER(12),
 	ROW_GROUP_ID            NUMBER(3),
 	ROW_PROJECT_ID          NUMBER(4),
 	ROW_ALG_INVOCATION_ID   NUMBER(12),
 	PRIMARY KEY (pubchem_substance_id)
);

CREATE TABLE apidb.PubChemSubstanceProperty (
 	pubchem_substance_property_id NUMBER(10),
 	pubchem_substance_id          NUMBER(10) NOT NULL,
 	property                VARCHAR2(20) NOT NULL,
 	value                   VARCHAR2(500) NOT NULL,
 	MODIFICATION_DATE       DATE,
 	USER_READ               NUMBER(1),
 	USER_WRITE              NUMBER(1),
 	GROUP_READ              NUMBER(1),
 	GROUP_WRITE             NUMBER(1),
 	OTHER_READ              NUMBER(1),
 	OTHER_WRITE             NUMBER(1),
 	ROW_USER_ID             NUMBER(12),
 	ROW_GROUP_ID            NUMBER(3),
 	ROW_PROJECT_ID          NUMBER(4),
 	ROW_ALG_INVOCATION_ID   NUMBER(12),
 	PRIMARY KEY (pubchem_substance_property_id),
	FOREIGN KEY (pubchem_substance_id) REFERENCES ApiDB.PubChemSubstance (pubchem_substance_id)
);

CREATE INDEX apidb.pcs_mod_ix ON apidb.PubChemSubstance (modification_date, pubchem_substance_id);
CREATE INDEX apidb.pcsp_mod_ix ON apidb.PubChemSubstanceProperty (modification_date, pubchem_substance_property_id);
CREATE INDEX apidb.pcsp_revix ON apidb.PubChemSubstanceProperty (pubchem_substance_id, pubchem_substance_property_id);


CREATE SEQUENCE apidb.PubChemSubstance_sq;
CREATE SEQUENCE apidb.PubChemSubstanceProperty_sq;


GRANT insert, select, update, delete ON apidb.PubChemSubstance TO gus_w;
GRANT select ON apidb.PubChemSubstance TO gus_r;
GRANT select ON apidb.PubChemSubstance_sq TO gus_w;

GRANT insert, select, update, delete ON apidb.PubChemSubstanceProperty TO gus_w;
GRANT select ON apidb.PubChemSubstanceProperty TO gus_r;
GRANT select ON apidb.PubChemSubstanceProperty_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'PubChemSubstance',
       'Standard', 'pubchem_substance_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'PubChemSubstance' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'PubChemSubstanceProperty',
       'Standard', 'pubchem_substance_property_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'PubChemSubstanceProperty' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);
------------------------------------------------------------------------------
exit;
