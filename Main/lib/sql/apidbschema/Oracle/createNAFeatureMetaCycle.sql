CREATE TABLE apidb.NAFeatureMetaCycle (
 na_feature_meta_cycle_id         NUMBER(10),
 na_feature_id	  		  NUMBER(10),
 protocol_app_node_id		  NUMBER(10) NOT NULL,
 period			      	  FLOAT(126),
 amplitude		      	  FLOAT(126),
 pvalue              		  FLOAT(126),
 modification_date            	  date NOT NULL,
 user_read                    	  NUMBER(1) NOT NULL,
 user_write                   	  NUMBER(1) NOT NULL,
 group_read                   	  NUMBER(1) NOT NULL,
 group_write                  	  NUMBER(1) NOT NULL,
 other_read                   	  NUMBER(1) NOT NULL,
 other_write                  	  NUMBER(1) NOT NULL,
 row_user_id                  	  NUMBER(12) NOT NULL,
 row_group_id                 	  NUMBER(3) NOT NULL,
 row_project_id               	  NUMBER(4) NOT NULL,
 row_alg_invocation_id        	  NUMBER(12) NOT NULL,
 FOREIGN KEY (na_feature_id) REFERENCES dots.NaFeatureImp,
 FOREIGN KEY (protocol_app_node_id) REFERENCES Study.ProtocolAppNode,
 PRIMARY KEY (na_feature_meta_cycle_id)
);
CREATE INDEX apidb.nafeatmetacyc_1 ON apidb.NaFeatureMetacycle (na_feature_id, na_feature_meta_cycle_id) TABLESPACE indx;
CREATE INDEX apidb.nafeatmetacyc_2 ON apidb.NaFeatureMetacycle (protocol_app_node_id, na_feature_meta_cycle_id) TABLESPACE indx;

--CREATE INDEX apidb.metacyc_revix0 ON apidb.MetaCycle (label, cycle_id) TABLESPACE indx;
--CREATE INDEX apidb.metacyc_revix1 ON apidb.MetaCycle (label, cycle_id) TABLESPACE indx;


GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.NAFeatureMetaCycle TO gus_w;
GRANT SELECT ON apidb.NAFeatureMetaCycle TO gus_r;

------------------------------------------------------------------------------

CREATE SEQUENCE apidb.NAFeatureMetaCycle_sq;
GRANT SELECT ON apidb.NAFeatureMetaCycle_sq TO gus_r;
GRANT SELECT ON apidb.NAFeatureMetaCycle_sq TO gus_w;

------------------------------------------------------------------------------

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'NAFeatureMetaCycle',
       'Standard', 'na_feature_meta_cycle_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MIN(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE lower('NAFeatureMetaCycle') NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);


exit;
