create table ApiDB.PhenotypeGrowthRate (
 phenotype_growth_rate_id           NUMERIC(10) ,
 na_feature_id                NUMERIC(10),
 protocol_app_node_id         NUMERIC(10) NOT NULL,
 phenotype                    VARCHAR(25),
 relative_growth_rate         NUMERIC(6,4),
 confidence                   NUMERIC(6,4),
 expected_variance            NUMERIC(6,4),
 rgr_ci_low                   NUMERIC(6,4),
 rgr_ci_high                  NUMERIC(6,4),
 times_analyzed               NUMERIC(2),
 construct                    VARCHAR(50),
 notes                        VARCHAR(250),
 modification_date              TIMESTAMP,
 user_read                      NUMERIC(1),
 user_write                     NUMERIC(1),
 group_read                     NUMERIC(1),
 group_write                    NUMERIC(1),
 other_read                     NUMERIC(1),
 other_write                    NUMERIC(1),
 row_user_id                    NUMERIC(12),
 row_group_id                   NUMERIC(3),
 row_project_id                 NUMERIC(4),
 row_alg_invocation_id          NUMERIC(12),
 FOREIGN KEY (na_feature_id) REFERENCES dots.NaFeatureImp,
 FOREIGN KEY (protocol_app_node_id) REFERENCES Study.ProtocolAppNode,
 PRIMARY KEY (phenotype_growth_rate_id)
);

create index phengrowthrate_1
  on apidb.PhenotypeGrowthRate (na_feature_id, phenotype_growth_rate_id) ;
create index phengrowthrate_2
  on apidb.PhenotypeGrowthRate (protocol_app_node_id, phenotype_growth_rate_id) ;

CREATE SEQUENCE apidb.PhenotypeGrowthRate_sq;

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.PhenotypeGrowthRate TO gus_w;
GRANT SELECT ON apidb.PhenotypeGrowthRate TO gus_r;
GRANT SELECT ON apidb.PhenotypeGrowthRate_sq TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'PhenotypeGrowthRate',
       'Standard', 'phenotype_growth_rate_id',
       d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM 
     (SELECT MIN(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'phenotypegrowthrate' NOT IN (SELECT LOWER(name) FROM core.TableInfo
                               WHERE database_id = d.database_id);
