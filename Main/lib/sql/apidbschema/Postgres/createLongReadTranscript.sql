
CREATE TABLE ApiDB.LongReadTranscript (
  long_read_transcript_id	NUMERIC(10) NOT NULL,
  gene_source_id       		varchar(100) NOT NULL,
  transcript_source_id         	varchar(100) NOT NULL,
  talon_gene_name             	varchar(100) NOT NULL,
  talon_transcript_name         varchar(100) NOT NULL,
  number_of_exon	 	NUMERIC(10) NOT NULL,
  transcript_length             NUMERIC(10) NOT NULL,
  gene_novelty             	varchar(100) NOT NULL,
  transcript_novelty           	varchar(100) NOT NULL,
  incomplete_splice_match_type  varchar(100) NOT NULL,
  min_Start             	NUMERIC(10) NOT NULL,
  max_End          		NUMERIC(10) NOT NULL,
  na_seq_source_id             	varchar(100) NOT NULL,
  external_database_release_id	NUMERIC(10) NOT NULL,
  count_data			TEXT NOT NULL,
  MODIFICATION_DATE     	TIMESTAMP,
  USER_READ             	NUMERIC(1),
  USER_WRITE            	NUMERIC(1),
  GROUP_READ            	NUMERIC(1),
  GROUP_WRITE           	NUMERIC(1),
  OTHER_READ            	NUMERIC(1),
  OTHER_WRITE           	NUMERIC(1),
  ROW_USER_ID           	NUMERIC(12),
  ROW_GROUP_ID          	NUMERIC(3),
  ROW_PROJECT_ID        	NUMERIC(4),
  ROW_ALG_INVOCATION_ID 	NUMERIC(12),
  PRIMARY KEY (long_read_transcript_id),
  FOREIGN KEY (external_database_release_id) REFERENCES SRes.ExternalDatabaseRelease (external_database_release_id)
);

CREATE SEQUENCE ApiDB.LongReadTranscript_sq;

GRANT insert, select, update, delete ON ApiDB.LongReadTranscript TO gus_w;
GRANT select ON ApiDB.LongReadTranscript TO gus_r;
GRANT select ON ApiDB.LongReadTranscript_sq TO gus_w;


INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'LongReadTranscript', 'Standard', 'long_read_transcript_id',
  d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'LongReadTranscript' NOT IN (SELECT name FROM core.TableInfo
                      WHERE database_id = d.database_id)
      ;

------------------------------------------------------------------------------
