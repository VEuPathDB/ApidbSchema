-- indexes on GUS tables

create index dots.AaSeq_source_ix
  on dots.AaSequenceImp (lower(source_id)) tablespace INDX;

create index dots.NaFeat_alleles_ix
  on dots.NaFeatureImp (subclass_view, number4, number5, na_sequence_id, na_feature_id)
  tablespace INDX;

create index dots.AaSequenceImp_string2_ix
  on dots.AaSequenceImp (string2, aa_sequence_id)
  tablespace INDX;

create index dots.nasequenceimp_string1_seq_ix
  on dots.NaSequenceImp (string1, external_database_release_id, na_sequence_id)
  tablespace INDX;

create index dots.nasequenceimp_string1_ix
  on dots.NaSequenceImp (string1, na_sequence_id)
  tablespace INDX;

create index dots.ExonOrder_ix
  on dots.NaFeatureImp (subclass_view, parent_id, number3, na_feature_id)
  tablespace INDX; 

create index dots.SeqvarStrain_ix
  on dots.NaFeatureImp (subclass_view, external_database_release_id, string9, na_feature_id)
  tablespace INDX; 

-- upgrade GUS_W to support CTXSYS indexes (Oracle Text)
GRANT EXECUTE ON CTXSYS.CTX_CLS TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_DDL TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_DOC TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_OUTPUT TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_QUERY TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_REPORT TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_THES TO GUS_W;
GRANT EXECUTE ON CTXSYS.CTX_ULEXER TO GUS_W;
GRANT EXECUTE ON CTXSYS.DRUE TO GUS_W;
GRANT EXECUTE ON CTXSYS.CATINDEXMETHODS TO GUS_W;
GRANT CREATE INDEXTYPE to GUS_W;
GRANT CREATE CLUSTER to GUS_W;
GRANT CREATE DATABASE LINK to GUS_W;
GRANT CREATE JOB to GUS_W;
GRANT CREATE PROCEDURE to GUS_W;
GRANT CREATE SEQUENCE to GUS_W;
GRANT CREATE SESSION to GUS_W;
GRANT CREATE SYNONYM to GUS_W;
GRANT CREATE TABLE to GUS_W;
GRANT CREATE TRIGGER to GUS_W;
GRANT CREATE TYPE to GUS_W;
GRANT CREATE VIEW to GUS_W;
GRANT MANAGE SCHEDULER to GUS_W;
GRANT SELECT ANY DICTIONARY to GUS_W;
 
-- GRANTs required for CTXSYS
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to core;
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to dots;
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to rad;
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to study;
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to sres;
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to tess;
GRANT CONNECT, RESOURCE, CTXAPP, GUS_W to prot;


-- schema changes for GUS tables

alter table dots.NaFeatureImp modify (source_id varchar2(80));

alter table sres.EnzymeClass modify (description varchar2(200));

alter table sres.GoEvidenceCode modify (name varchar2(20));

alter table sres.dbref modify (SECONDARY_IDENTIFIER varchar2(150));
alter table sres.dbref modify (LOWERCASE_SECONDARY_IDENTIFIER varchar2(150));

alter table dots.SequencePiece add ( start_position number(12), end_position number(12) );

alter table dots.NaFeatureImp modify (name varchar2(80));

alter table dots.Est modify (accession varchar2(50));

-- indexes for orthomcl keyword and pfam searches
CREATE INDEX dots.aasequenceimp_ind_desc ON dots.AaSequenceImp (description)
    indextype IS ctxsys.ctxcat;
    
CREATE INDEX sres.dbref_ind_id2 ON sres.DbRef (secondary_identifier)
    indextype IS ctxsys.ctxcat;

CREATE INDEX sres.dbref_ind_rmk ON sres.DbRef (remark)
    indextype IS ctxsys.ctxcat;


-- add this to prevent race condition in which we write duplicate rows
-- when plugins first run in a workflow on a brand new instance
ALTER TABLE core.algorithmimplementation
ADD CONSTRAINT alg_imp_uniq
UNIQUE (executable, cvs_revision);


-- add columns to a GUS view
-- drop first, because this view already exists from GUS install
-- (and don't drop in dropGusTuning.sql)
DROP VIEW rad.DifferentialExpression;
CREATE VIEW rad.DifferentialExpression AS
SELECT
   analysis_result_id,
   subclass_view,
   analysis_id,
   table_id,
   row_id,
   float1 as fold_change,
   float2 as confidence,
   float3 as pvalue_mant,
   number1 as pvalue_exp,
   modification_date,
   user_read,
   user_write,
   group_read,
   group_write,
   other_read,
   other_write,
   row_user_id,
   row_group_id,
   row_project_id,
   row_alg_invocation_id
FROM RAD.AnalysisResultImp
WHERE subclass_view = 'DifferentialExpression'
WITH CHECK OPTION;

GRANT SELECT ON rad.DifferentialExpression TO gus_r;
GRANT INSERT, UPDATE, DELETE ON rad.DifferentialExpression TO gus_w;


exit
