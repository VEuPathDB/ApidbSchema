create table apidb.Snp (
    na_sequence_id               NUMERIC(10) not null,/* references dots.NaSequenceImp */
    location                     NUMERIC(10) not null,
    snp_id                       NUMERIC(12) not null,
    gene_na_feature_id           NUMERIC(10), /* references dots.NaFeatureImp */
    source_id                    varchar(100) not null,
    reference_strain             varchar(50) not null,
    reference_na                 varchar(1) not null,
    reference_aa                 varchar(1),
    position_in_cds              NUMERIC(5),
    position_in_protein          NUMERIC(5),
    external_database_release_id NUMERIC(10) not null,/* references sres.externaldatabaserelease */
    has_nonsynonymous_allele     NUMERIC(1),  /* if 1 then at least one allele non-synonymous .. not sure in practice that we use this */
    major_allele                 varchar(1) not null,
    minor_allele                 varchar(10) not null,  /* note there could be  more than one but we are only loading first based on sorted list */
    major_allele_count           NUMERIC(5) not null,
    minor_allele_count           NUMERIC(5) not null,
    total_allele_count           NUMERIC(5),
    major_product                varchar(1),
    minor_product                varchar(1),
    distinct_strain_count        NUMERIC(3),
    distinct_allele_count        NUMERIC(3),
    is_coding                    NUMERIC(1),
    has_stop_codon               NUMERIC(1),
    positions_in_cds_full        varchar(2500),
    positions_in_protein_full    varchar(2500),
    reference_aa_full            varchar(2500),
    modification_date            TIMESTAMP,
    PRIMARY KEY (snp_id)
);

create sequence apidb.Snp_sq;

-- no indexes created in this file for this table.  they are created by addConstraintsAndIndexesToSnpTables.sql instead, to be run at the end of workflow


grant select on apidb.Snp to gus_r;
grant insert, select, update, delete on apidb.Snp to gus_w;
grant select ON apidb.Snp_sq TO gus_w;

--------------------------------------------------------------------------------
create table apidb.SequenceVariation (
    sequence_variation_id        NUMERIC(12) not null,
    na_sequence_id               NUMERIC(10) not null,
    location                     NUMERIC(10) not null,
    strain                       varchar(50) not null,
    allele                       varchar(1) not null,
    matches_reference            NUMERIC(3) not null,
    product                      varchar(1),
    external_database_release_id NUMERIC(10) not null,
    snp_ext_db_rls_id            NUMERIC(10) not null,
    p_value                      float8,
    read_percent                 float8,
    coverage                     NUMERIC(12),
    quality                      NUMERIC(12),
    ref_na_sequence_id           NUMERIC(10) not null,
    protocol_app_node_id         NUMERIC(10) NOT NULL,
    products_full                varchar(2500),
    diff_from_adjacent_snp       NUMERIC(1),
    modification_date            TIMESTAMP,
    PRIMARY KEY (sequence_variation_id)
);

create sequence apidb.SequenceVariation_sq;

-- no indexes created in this file for this table.  they are created by addConstraintsAndIndexesToSnpTables.sql instead, to be run at the end of workflow

grant select on apidb.SequenceVariation to gus_r;
grant insert, select, update, delete on apidb.SequenceVariation to gus_w;
grant select ON apidb.SequenceVariation_sq TO gus_w;



INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'Snp',
       'Standard', 'snp_id',
       d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'snp' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);


INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT NEXTVAL('core.tableinfo_sq'), 'SequenceVariation',
       'Standard', 'sequence_variation_id',
       d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'sequencevariation' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

