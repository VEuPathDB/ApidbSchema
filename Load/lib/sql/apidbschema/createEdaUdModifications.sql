set CONCAT OFF;

ALTER TABLE ApidbUserDatasets.study 
ADD (user_dataset_id NUMBER(20));

ALTER TABLE ApidbUserDatasets.study 
ADD (CONSTRAINT edastd_fk FOREIGN KEY (user_dataset_id) 
REFERENCES apidbUserDatasets.InstalledUserDataset);


CREATE TABLE ApidbUserDatasets.DatasetAttributes (
 dataset_id NUMBER(12) NOT NULL,
 user_dataset_id  NUMBER(20) NOT NULL,
 study_stable_id varchar2(200),
 dataset_stable_id varchar2(200) NOT NULL,
 name              varchar2(100),
 description              varchar2(4000),
 modification_date            DATE NOT NULL,
 user_read                    NUMBER(1) NOT NULL,
 user_write                   NUMBER(1) NOT NULL,
 group_read                   NUMBER(1) NOT NULL,
 group_write                  NUMBER(1) NOT NULL,
 other_read                   NUMBER(1) NOT NULL,
 other_write                  NUMBER(1) NOT NULL,
 row_user_id                  NUMBER(12) NOT NULL,
 row_group_id                 NUMBER(3) NOT NULL,
 row_project_id               NUMBER(4) NOT NULL,
 row_alg_invocation_id        NUMBER(12) NOT NULL,
 FOREIGN KEY (user_dataset_id) REFERENCES apidbUserDatasets.InstalledUserDataset,
 PRIMARY KEY (dataset_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON ApidbUserDatasets.DatasetAttributes TO gus_w;
GRANT SELECT ON ApidbUserDatasets.DatasetAttributes TO gus_r;

CREATE SEQUENCE ApidbUserDatasets.DatasetAttributes_sq;
GRANT SELECT ON ApidbUserDatasets.DatasetAttributes_sq TO gus_w;
GRANT SELECT ON ApidbUserDatasets.DatasetAttributes_sq TO gus_r;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'DatasetAttributes',
       'Standard', 'dataset_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = lower('apidbuserdatasets')) d
WHERE 'datasetattributes' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

-----------------------------------------------------------



exit;
