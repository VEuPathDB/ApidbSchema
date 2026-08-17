
-- Track the relationship between a workflow's artifact and its VDI ID
create table apidb.WorkflowArtifactVdiId (
  workflow_id number(10) NOT NULL,
  organism_abbrev varchar(20),  -- nullable for, eg, the global workflow
  artifact_name varchar(500) NOT NULL,
  vdi_id varchar2(32) NOT NULL,
  PRIMARY KEY (workflow_id, organism_abbrev, artifact_name),
  UNIQUE (vdi_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.WorkflowArtifactVdiId TO gus_w;
GRANT SELECT ON apidb.WorkflowArtifactVdiId TO gus_r;

----------------------------------------------------------------------------

-- Capture the time boundaries of the most recent batch of tuning tables submitted to VDI for a given data source
create table apidb.WorkflowVdiTuningTableBatch (
  workflow_id number(10) NOT NULL,
  organism_abbrev varchar(20),  -- nullable for eg global workflow
  start_timestamp DATE NOT NULL,  -- time from apidb.tuningtable
  end_timestamp DATE NOT NULL,    -- time from apidb.tuningtable
  is_complete number(1)           -- =1 if complete
  PRIMARY KEY (workflow_id, organism_abbrev)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.WorkflowTuningTableBatch TO gus_w;
GRANT SELECT ON apidb.WorkflowTuningTableBatch TO gus_r;

----------------------------------------------------------------------------

-- Track the status of workflow artifacts submitted to VDI.  See the VDI API for expected status values.
create table apidb.WorkflowVdiStatus (
  vdi_id varchar2(32) NOT NULL,
  modification_time DATE NOT NULL,  -- last status update
  vdi_import_status varchar(30),
  vdi_install_status varchar(30),
  vdi_meta_status varchar(30),
  vdi_delete_status varchar(30),
  vdi_error_message varchar(500) -- error message for most recent failure.  Only track one.
  PRIMARY KEY (vdi_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.WorkflowVdiStatus TO gus_w;
GRANT SELECT ON apidb.WorkflowVdiStatus TO gus_r;


exit;
