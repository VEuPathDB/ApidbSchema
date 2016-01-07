create table apidb.TranscriptDetail (
      SOURCE_ID VARCHAR2(100 BYTE),
      GENE_SOURCE_ID VARCHAR2(100 BYTE),
      PROJECT_ID VARCHAR2(50 BYTE),
      FIELD_NAME VARCHAR(50 BYTE),
      FIELD_TITLE VARCHAR(1000 BYTE),
      ROW_COUNT NUMBER,
      CONTENT CLOB,
      MODIFICATION_DATE DATE
);

CREATE UNIQUE INDEX apidb.transcriptdtl_idx01 ON apidb.TranscriptDetail(source_id, project_id, field_name) tablespace indx;
CREATE INDEX apidb.transcriptdtl_idx02 ON apidb.TranscriptDetail(field_name, source_id, gene_source_id, project_id) tablespace indx;
CREATE INDEX apidb.transcriptdtl_idx03 ON apidb.TranscriptDetail(row_count, source_id, gene_source_id, project_id) tablespace indx;

CREATE INDEX apidb.transcript_text_ix on apidb.TranscriptDetail(content)
indextype is ctxsys.context
parameters('DATASTORE CTXSYS.DEFAULT_DATASTORE SYNC (ON COMMIT)');

CREATE TRIGGER apidb.TranscriptDtl_md_tg
BEFORE UPDATE OR INSERT ON apidb.TranscriptDetail
FOR EACH ROW
BEGIN
  :new.modification_date := sysdate;
END;
/

GRANT insert, select, update, delete ON apidb.TranscriptDetail TO gus_w;
GRANT select ON apidb.TranscriptDetail TO gus_r;

------------------------------------------------------------------------------

create table apidb.IsolateDetail (
      SOURCE_ID VARCHAR2(50 BYTE),
      PROJECT_ID VARCHAR2(50 BYTE),
      FIELD_NAME VARCHAR(50 BYTE),
      FIELD_TITLE VARCHAR(1000 BYTE),
      ROW_COUNT NUMBER,
      CONTENT CLOB,
      MODIFICATION_DATE DATE
);

CREATE INDEX apidb.isolatedtl_idx01 ON apidb.IsolateDetail(source_id, project_id, field_name);
CREATE INDEX apidb.isolatedtl_idx02 ON apidb.IsolateDetail(field_name, source_id);
CREATE INDEX apidb.isolatedtl_idx03 ON apidb.IsolateDetail(row_count, source_id);

CREATE INDEX apidb.isolate_text_ix on apidb.IsolateDetail(content)
indextype is ctxsys.context
parameters('DATASTORE CTXSYS.DEFAULT_DATASTORE SYNC (ON COMMIT)');

CREATE TRIGGER apidb.IsolateDtl_md_tg
BEFORE UPDATE OR INSERT ON apidb.IsolateDetail
FOR EACH ROW
BEGIN
  :new.modification_date := sysdate;
END;
/

GRANT insert, select, update, delete ON apidb.IsolateDetail TO gus_w;
GRANT select ON apidb.IsolateDetail TO gus_r;

------------------------------------------------------------------------------

create table apidb.SequenceDetail (
      SOURCE_ID VARCHAR2(50 BYTE),
      PROJECT_ID VARCHAR2(50 BYTE),
      FIELD_NAME VARCHAR(50 BYTE),
      FIELD_TITLE VARCHAR(1000 BYTE),
      ROW_COUNT NUMBER,
      CONTENT CLOB,
      MODIFICATION_DATE DATE
);

CREATE INDEX apidb.sequencedtl_idx01 ON apidb.SequenceDetail(source_id, project_id, field_name);
CREATE INDEX apidb.sequencedtl_idx02 ON apidb.SequenceDetail(field_name, source_id);
CREATE INDEX apidb.sequencedtl_idx03 ON apidb.SequenceDetail(row_count, source_id);

CREATE TRIGGER apidb.SeqDtl_md_tg
BEFORE UPDATE OR INSERT ON apidb.SequenceDetail
FOR EACH ROW
BEGIN
  :new.modification_date := sysdate;
END;
/

GRANT insert, select, update, delete ON apidb.SequenceDetail TO gus_w;
GRANT select ON apidb.SequenceDetail TO gus_r;

------------------------------------------------------------------------------

create table apidb.OrthomclSequenceDetail (
      FULL_ID VARCHAR2(50 BYTE),
      FIELD_NAME VARCHAR(50 BYTE),
      FIELD_TITLE VARCHAR(1000 BYTE),
      ROW_COUNT NUMBER,
      CONTENT CLOB,
      MODIFICATION_DATE DATE
);

CREATE INDEX apidb.sequence_text_ix on apidb.OrthomclSequenceDetail(content)
indextype is ctxsys.context
parameters('DATASTORE CTXSYS.DEFAULT_DATASTORE SYNC (ON COMMIT)');

CREATE TRIGGER apidb.OrtSeqDtl_md_tg
BEFORE UPDATE OR INSERT ON apidb.OrthomclSequenceDetail
FOR EACH ROW
BEGIN
  :new.modification_date := sysdate;
END;
/

GRANT insert, select, update, delete ON apidb.OrthomclSequenceDetail TO gus_w;
GRANT select ON apidb.OrthomclSequenceDetail TO gus_r;

------------------------------------------------------------------------------

-- for OrthoMCL
create table apidb.GroupDetail (
      GROUP_NAME VARCHAR2(50 BYTE),
      FIELD_NAME VARCHAR(50 BYTE),
      FIELD_TITLE VARCHAR(1000 BYTE),
      ROW_COUNT NUMBER,
      CONTENT CLOB,
      MODIFICATION_DATE DATE
);

CREATE INDEX apidb.group_text_ix on apidb.GroupDetail(content)
indextype is ctxsys.context
parameters('DATASTORE CTXSYS.DEFAULT_DATASTORE SYNC (ON COMMIT)');

CREATE TRIGGER apidb.GrpDtl_md_tg
BEFORE UPDATE OR INSERT ON apidb.GroupDetail
FOR EACH ROW
BEGIN
  :new.modification_date := sysdate;
END;
/

GRANT insert, select, update, delete ON apidb.GroupDetail TO gus_w;
GRANT select ON apidb.GroupDetail TO gus_r;

------------------------------------------------------------------------------
-- TranscriptGff (formerly TranscriptTable) holds data used for the GFF download

CREATE TABLE apidb.TranscriptGff (
 wdk_table_id number(10) not null,
 source_id  VARCHAR2(50),
 project_id  VARCHAR2(50),
 table_name VARCHAR2(80),
 row_count  NUMBER(4),
 content    CLOB,
 primary key (wdk_table_id),
 modification_date date
);

CREATE INDEX apidb.gtab_ix
       ON apidb.TranscriptGff (source_id, table_name, row_count);
CREATE INDEX apidb.gtab_name_ix
       ON apidb.TranscriptGff (table_name, source_id, row_count);

GRANT insert, select, update, delete ON ApiDB.TranscriptGff TO gus_w;
GRANT select ON ApiDB.TranscriptGff TO gus_r;

CREATE OR REPLACE TRIGGER apidb.TranscriptGff_md_tg
before update or insert on apidb.TranscriptGff
for each row
begin
  :new.modification_date := sysdate;
end;
/

------------------------------------------------------------------------------
CREATE SEQUENCE apidb.transcriptGff_pkseq;

GRANT SELECT ON apidb.transcriptGff_pkseq TO gus_w;

------------------------------------------------------------------------------

create table apidb.CompoundDetail (
      SOURCE_ID VARCHAR2(50 BYTE),
      PROJECT_ID VARCHAR2(50 BYTE),
      FIELD_NAME VARCHAR(50 BYTE),
      FIELD_TITLE VARCHAR(1000 BYTE),
      ROW_COUNT NUMBER,
      CONTENT CLOB,
      MODIFICATION_DATE DATE
);

CREATE INDEX apidb.compounddtl_idx01 ON apidb.CompoundDetail(source_id, project_id, field_name);
CREATE INDEX apidb.compounddtl_idx02 ON apidb.CompoundDetail(field_name, source_id);
CREATE INDEX apidb.compounddtl_idx03 ON apidb.CompoundDetail(row_count, source_id);

CREATE INDEX apidb.compound_text_ix on apidb.CompoundDetail(content)
indextype is ctxsys.context
parameters('DATASTORE CTXSYS.DEFAULT_DATASTORE SYNC (ON COMMIT)');

CREATE TRIGGER apidb.CompoundDtl_md_tg
BEFORE UPDATE OR INSERT ON apidb.CompoundDetail
FOR EACH ROW
BEGIN
  :new.modification_date := sysdate;
END;
/

GRANT insert, select, update, delete ON apidb.CompoundDetail TO gus_w;
GRANT select ON apidb.CompoundDetail TO gus_r;

------------------------------------------------------------------------------



exit;
