CREATE TABLE ApiDB.ProteinDataBank (
  protein_data_bank_id  NUMERIC(10) NOT NULL,
  taxon_id              NUMERIC(12) NOT NULL,
  source_id             VARCHAR(60) NOT NULL,
  description           VARCHAR(2000),
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
  FOREIGN KEY (taxon_id) REFERENCES sres.taxon (taxon_id),
  FOREIGN KEY (EXTERNAL_DATABASE_RELEASE_ID) REFERENCES sres.ExternalDatabaseRelease (EXTERNAL_DATABASE_RELEASE_ID),
  PRIMARY KEY (protein_data_bank_id)
);

CREATE SEQUENCE ApiDB.ProteinDataBank_sq;

GRANT insert, select, update, delete ON ApiDB.ProteinDataBank TO gus_w;
GRANT select ON ApiDB.ProteinDataBank TO gus_r;
GRANT select ON ApiDB.ProteinDataBank_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'ProteinDataBank', 'Standard', 'protein_data_bank_id',
  d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'ProteinDataBank' NOT IN (SELECT name FROM core.TableInfo
                      WHERE database_id = d.database_id);



CREATE TABLE ApiDB.PDBSimilarity (
  pdb_similarity_id  NUMERIC(10) NOT NULL,
  protein_data_bank_id              NUMERIC(10) NOT NULL,
  aa_sequence_id             NUMERIC(10) NOT NULL,
  pident                    NUMERIC(5),
  length                    NUMERIC(5),
  mismatch                  NUMERIC(5),
  query_start               NUMERIC(12),
  query_end                 NUMERIC(12),
  subject_start             NUMERIC(12),
  subject_end               NUMERIC(12),
  evalue_mant               FLOAT,
  evalue_exp                DOUBLE PRECISION,
  bit_score                 FLOAT,
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
  FOREIGN KEY (protein_data_bank_id) REFERENCES apidb.proteindatabank (protein_data_bank_id),
  FOREIGN KEY (aa_sequence_id) REFERENCES dots.aasequenceimp (aa_sequence_id),
  FOREIGN KEY (EXTERNAL_DATABASE_RELEASE_ID) REFERENCES sres.ExternalDatabaseRelease (EXTERNAL_DATABASE_RELEASE_ID),
  PRIMARY KEY (pdb_similarity_id)
);

CREATE SEQUENCE ApiDB.PDBSimilarity_sq;

GRANT insert, select, update, delete ON ApiDB.PDBSimilarity TO gus_w;
GRANT select ON ApiDB.PDBSimilarity TO gus_r;
GRANT select ON ApiDB.PDBSimilarity_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'PDBSimilarity', 'Standard', 'pdb_similarity_id',
  d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'PDBSimilarity' NOT IN (SELECT name FROM core.TableInfo
                      WHERE database_id = d.database_id);
