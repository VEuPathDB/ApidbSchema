CREATE TABLE ApiDB.MassSpecPeptide (
  mass_spec_peptide_id        NUMERIC(10) NOT NULL,
  protein_source_id           varchar(60) not null,
  peptide_start               numeric(12) not null,
  peptide_end                 numeric(12) not null,
  spectrum_count              number(6),
  sample                      varchar(200) not null,
  peptide_sequence            varchar(4000) not null,
  external_database_release_id NUMERIC(10) NOT NULL,
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
  FOREIGN KEY (EXTERNAL_DATABASE_RELEASE_ID) REFERENCES sres.ExternalDatabaseRelease (EXTERNAL_DATABASE_RELEASE_ID),
  PRIMARY KEY (mass_spec_peptide_id)
);

CREATE SEQUENCE ApiDB.MassSpecPeptide_sq;

GRANT insert, select, update, delete ON ApiDB.MassSpecPeptide TO gus_w;
GRANT select ON ApiDB.MassSpecPeptide TO gus_r;
GRANT select ON ApiDB.MassSpecPeptide_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'MassSpecPeptide', 'Standard', 'mass_spec_peptide_id',
  d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'MassSpecPeptide' NOT IN (SELECT name FROM core.TableInfo
                      WHERE database_id = d.database_id)
;


CREATE TABLE ApiDB.ModifiedMassSpecPeptide (
  modified_mass_spec_peptide_id        NUMERIC(10) NOT NULL,
  protein_source_id           varchar(60) not null,
  peptide_start               numeric(12) not null,
  peptide_end                 numeric(12) not null,
  spectrum_count              number(6),
  sample                      varchar(200) not null,
  peptide_sequence            varchar(4000) not null,
  external_database_release_id NUMERIC(10) NOT NULL,
  residue                      varchar(10) not null
  residue_location             numeric(12) not null
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
  FOREIGN KEY (EXTERNAL_DATABASE_RELEASE_ID) REFERENCES sres.ExternalDatabaseRelease (EXTERNAL_DATABASE_RELEASE_ID),
  PRIMARY KEY (modified_mass_spec_peptide_id)
);

CREATE SEQUENCE ApiDB.ModifiedMassSpecPeptide_sq;

GRANT insert, select, update, delete ON ApiDB.ModifiedMassSpecPeptide TO gus_w;
GRANT select ON ApiDB.ModifiedMassSpecPeptide TO gus_r;
GRANT select ON ApiDB.ModifiedMassSpecPeptide_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'ModifiedMassSpecPeptide', 'Standard', 'modified_mass_spec_peptide_id',
  d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'ModifiedMassSpecPeptide' NOT IN (SELECT name FROM core.TableInfo
                      WHERE database_id = d.database_id)
;
