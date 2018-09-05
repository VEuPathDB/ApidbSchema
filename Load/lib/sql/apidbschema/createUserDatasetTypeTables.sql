create table ApiDBUserDatasets.UD_GeneId (
USER_DATASET_ID          NUMBER(20),     
gene_SOURCE_ID                             VARCHAR2(100),  
FOREIGN KEY (user_dataset_id) REFERENCES ApiDBUserDatasets.InstalledUserDataset
);

CREATE unique INDEX ApiDBUserDatasets.UD_GENEID_idx1 ON ApiDBUserDatasets.UD_geneid (user_dataset_id, gene_source_id) tablespace indx;

GRANT insert, select, update, delete ON ApiDBUserDatasets.UD_GeneId TO gus_w;
GRANT select ON ApiDBUserDatasets.UD_GeneId TO gus_r;

----------------------------------------------------------------------------
create table ApiDBUserDatasets.UD_PROTOCOLAPPNODE (
PROTOCOL_APP_NODE_ID         NUMBER(10) not null,     
TYPE_ID                               NUMBER(10),     
NAME                         VARCHAR2(200) not null,  
DESCRIPTION                           VARCHAR2(1000), 
URI                                   VARCHAR2(300),  
USER_DATASET_ID          NUMBER(20),     
SOURCE_ID                             VARCHAR2(100),  
SUBTYPE_ID                            NUMBER(10),     
TAXON_ID                              NUMBER(10),     
NODE_ORDER_NUM                        NUMBER(10),     
ISA_TYPE                              VARCHAR2(50),   
MODIFICATION_DATE            DATE not null,         
USER_READ                    NUMBER(1) not null ,      
USER_WRITE                   NUMBER(1) not null ,      
GROUP_READ                   NUMBER(1) not null ,      
GROUP_WRITE                  NUMBER(1) not null ,      
OTHER_READ                   NUMBER(1) not null ,      
OTHER_WRITE                  NUMBER(1) not null ,      
ROW_USER_ID                  NUMBER(12) not null ,     
ROW_GROUP_ID                 NUMBER(4) not null ,      
ROW_PROJECT_ID               NUMBER(4) not null ,      
ROW_ALG_INVOCATION_ID        NUMBER(12) not null ,  
 FOREIGN KEY (user_dataset_id) REFERENCES ApiDBUserDatasets.InstalledUserDataset,
 PRIMARY KEY (protocol_app_node_id)
);

CREATE INDEX ApiDBUserDatasets.UD_PAN_idx1 ON ApiDBUserDatasets.UD_PROTOCOLAPPNODE (type_id) tablespace indx;
CREATE INDEX ApiDBUserDatasets.UD_PAN_idx2 ON ApiDBUserDatasets.UD_PROTOCOLAPPNODE (user_dataset_id) tablespace indx;
CREATE INDEX ApiDBUserDatasets.UD_PAN_idx3 ON ApiDBUserDatasets.UD_PROTOCOLAPPNODE (subtype_id) tablespace indx;
CREATE INDEX ApiDBUserDatasets.UD_PAN_idx4 ON ApiDBUserDatasets.UD_PROTOCOLAPPNODE (taxon_id, protocol_app_node_id) tablespace indx;

create sequence ApiDBUserDatasets.UD_ProtocolAppNode_sq;

GRANT insert, select, update, delete ON ApiDBUserDatasets.UD_ProtocolAppNode TO gus_w;
GRANT select ON ApiDBUserDatasets.UD_ProtocolAppNode TO gus_r;
GRANT select ON ApiDBUserDatasets.UD_ProtocolAppNode_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'UD_ProtocolAppNode',
       'Standard', 'protocol_app_node_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApidbUserDatasets') d
WHERE 'UD_ProtocolAppNode' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);


-----------------------------------------------------------------------------------------------------

create table ApiDBUserDatasets.UD_NaFeatureExpression (
NA_FEAT_EXPRESSION_ID NUMBER(12) NOT NULL,    
PROTOCOL_APP_NODE_ID  NUMBER(10) NOT NULL,    
NA_FEATURE_ID         NUMBER(10) NOT NULL,    
VALUE                          FLOAT(126),    
CONFIDENCE                     FLOAT(126),    
STANDARD_ERROR                 FLOAT(126),    
CATEGORICAL_VALUE              VARCHAR2(100), 
PERCENTILE_CHANNEL1            FLOAT(126),    
PERCENTILE_CHANNEL2            FLOAT(126),   
MODIFICATION_DATE     DATE  NOT NULL,         
USER_READ             NUMBER(1) NOT NULL,     
USER_WRITE            NUMBER(1) NOT NULL,     
GROUP_READ            NUMBER(1) NOT NULL,     
GROUP_WRITE           NUMBER(1) NOT NULL,     
OTHER_READ            NUMBER(1) NOT NULL,     
OTHER_WRITE           NUMBER(1) NOT NULL,     
ROW_USER_ID           NUMBER(12) NOT NULL,    
ROW_GROUP_ID          NUMBER(4) NOT NULL,     
ROW_PROJECT_ID        NUMBER(4) NOT NULL,     
ROW_ALG_INVOCATION_ID NUMBER(12) NOT NULL,    
 FOREIGN KEY (PROTOCOL_APP_NODE_ID) REFERENCES ApiDBUserDatasets.UD_PROTOCOLAPPNODE,
 PRIMARY KEY (NA_FEAT_EXPRESSION_ID)
);

CREATE INDEX ApiDBUserDatasets.UD_NFE_idx1 ON ApiDBUserDatasets.UD_NaFeatureExpression (protocol_app_node_id) tablespace indx;
CREATE INDEX ApiDBUserDatasets.UD_NFE_idx2 ON ApiDBUserDatasets.UD_NaFeatureExpression (na_feature_id) tablespace indx;
CREATE unique INDEX ApiDBUserDatasets.UD_NFE_idx3 ON ApiDBUserDatasets.UD_NaFeatureExpression (na_feature_id, protocol_app_node_id) tablespace indx;

create sequence ApiDBUserDatasets.UD_NaFeatureExpression_sq;

GRANT insert, select, update, delete ON ApiDBUserDatasets.UD_NaFeatureExpression TO gus_w;
GRANT select ON ApiDBUserDatasets.UD_NaFeatureExpression TO gus_r;
GRANT select ON ApiDBUserDatasets.UD_NaFeatureExpression_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'UD_NaFeatureExpression',
       'Standard', 'NA_FEAT_EXPRESSION_ID',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApidbUserDatasets') d
WHERE 'UD_NaFeatureExpression' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);

--------------------------------------------------------------------------------
create table ApiDBUserDatasets.ProfileSet (
 profile_set_id number(20),
 user_dataset_id number(20),
 modification_date            date not null,
 user_read                    number(1) not null,
 user_write                   number(1) not null,
 group_read                   number(1) not null,
 group_write                  number(1) not null,
 other_read                   number(1) not null,
 other_write                  number(1) not null,
 row_user_id                  number(12) not null,
 row_group_id                 number(4) not null,
 row_project_id               number(4) not null,
 row_alg_invocation_id        number(12) not null,
 foreign key (user_dataset_id) references ApiDBUserDatasets.InstalledUserDataset,
 primary key (profile_set_id)
);

create index ApiDBUserDatasets.pset_idx1
  on ApiDBUserDatasets.ProfileSet
     (profile_set_id, user_dataset_id)
  tablespace indx;

create sequence ApiDBUserDatasets.profileset_sq;

grant insert, select, update, delete on ApiDBUserDatasets.ProfileSet to gus_w;
grant select on ApiDBUserDatasets.ProfileSet to gus_r;
grant select on ApiDBUserDatasets.profileSet_sq to gus_w;

insert into core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
select core.tableinfo_sq.nextval, 'ProfileSet',
       'Standard', 'PROFILE_SET_ID',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
from dual,
     (select max(project_id) as project_id from core.ProjectInfo) p,
     (select database_id
      from core.DatabaseInfo
      where lower(name) = lower('ApidbUserDatasets')) d
where lower('ProfileSet') not in (select lower(name)
                             from core.TableInfo
                             where database_id = d.database_id);
--------------------------------------------------------------------------------
create table ApiDBUserDatasets.Profile (
 profile_id                   number(20),
 profile_set_id               number(20),
 dataset_type                 varchar2(50),
 dataset_subtype              varchar2(50),
 profile_type                 varchar2(20),
 source_id                    varchar2(400),
 profile_study_id             number(5),
 profile_set_name             varchar2(400),
 profile_set_suffix           varchar2(50),
 profile_as_string            varchar2(4000),
 max_value                    number,
 min_value                    number,
 max_timepoint                varchar2(200),
 min_timepoint                varchar2(200),
 modification_date            date not null,
 user_read                    number(1) not null,
 user_write                   number(1) not null,
 group_read                   number(1) not null,
 group_write                  number(1) not null,
 other_read                   number(1) not null,
 other_write                  number(1) not null,
 row_user_id                  number(12) not null,
 row_group_id                 number(4) not null,
 row_project_id               number(4) not null,
 row_alg_invocation_id        number(12) not null,
 foreign key (profile_set_id) references ApiDBUserDatasets.ProfileSet,
 primary key (profile_id)
);

create index ApiDBUserDatasets.prf_idx1
  on ApiDBUserDatasets.Profile
     (profile_set_id, profile_id)
  tablespace indx;

create sequence ApiDBUserDatasets.profile_sq;

grant insert, select, update, delete on ApiDBUserDatasets.Profile to gus_w;
grant select on ApiDBUserDatasets.Profile to gus_r;
grant select on ApiDBUserDatasets.profile_sq to gus_w;

insert into core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
select core.tableinfo_sq.nextval, 'Profile',
       'Standard', 'PROFILE_ID',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
from dual,
     (select max(project_id) as project_id from core.ProjectInfo) p,
     (select database_id
      from core.DatabaseInfo
      where lower(name) = lower('ApidbUserDatasets')) d
where lower('Profile') not in (select lower(name)
                             from core.TableInfo
                             where database_id = d.database_id);
--------------------------------------------------------------------------------
exit;



