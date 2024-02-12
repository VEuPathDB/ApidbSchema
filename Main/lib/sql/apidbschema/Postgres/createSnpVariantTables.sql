create table apidb.Variant (
  VARIANT_ID                   NUMERIC(12) not null,
  NA_SEQUENCE_ID               NUMERIC(10) not null,
  GENE_NA_FEATURE_ID           NUMERIC(10), /* references dots.transcript */
  LOCATION                     NUMERIC(10) not null,
  SOURCE_ID                    varchar(100) not null,
  REFERENCE_STRAIN             varchar(50) not null,
  REFERENCE_NA                 varchar(10) not null,
  REFERENCE_AA                 varchar(1),
  EXTERNAL_DATABASE_RELEASE_ID NUMERIC(10) not null,/* references sres.externaldatabaserelease */
  HAS_NONSYNONOMOUS_ALLELE     NUMERIC(1),  /* if 1 then at least one allele non-synonymous .. not sure in practice that we use this */
  MAJOR_ALLELE                 varchar(10) not null,
  MINOR_ALLELE                 varchar(10) not null,  /* note there could be  more. Loading second most common. */
  MAJOR_ALLELE_COUNT           NUMERIC(5) not null,
  MINOR_ALLELE_COUNT           NUMERIC(5) not null,
  TOTAL_ALLELE_COUNT           NUMERIC(5),
  MAJOR_PRODUCT                varchar(5),
  MINOR_PRODUCT                varchar(5),
  DISTINCT_STRAIN_COUNT        NUMERIC(3),
  DISTINCT_ALLELE_COUNT        NUMERIC(3),
  HAS_CODING_MUTATION          NUMERIC(1),
  HAS_STOP_CODON               NUMERIC(1),
  REF_CODON                    varchar(3),
  modification_date            timestamp,
  USER_READ                    NUMERIC(1),
  USER_WRITE                   NUMERIC(1),
  GROUP_READ                   NUMERIC(1),
  GROUP_WRITE                  NUMERIC(1),
  OTHER_READ                   NUMERIC(1),
  OTHER_WRITE                  NUMERIC(1),
  ROW_USER_ID                  NUMERIC(12),
  ROW_GROUP_ID                 NUMERIC(3),
  ROW_PROJECT_ID               NUMERIC(4),
  ROW_ALG_INVOCATION_ID        NUMERIC(12),
  PRIMARY KEY (variant_id),
  FOREIGN KEY (NA_SEQUENCE_ID) REFERENCES dots.nasequenceimp (NA_SEQUENCE_ID),
  FOREIGN KEY (EXTERNAL_DATABASE_RELEASE_ID) REFERENCES sres.externaldatabaserelease (EXTERNAL_DATABASE_RELEASE_ID),
);

create sequence apidb.Variant_sq;

grant select on apidb.variant to gus_r;
grant insert, select, update, delete on apidb.variant to gus_w;
grant select ON apidb.variant_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'Variant', 'Standard', 'variant_id',
    d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
    p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'Variant' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);

--------------------------------------------------------------------------------

create table apidb.VariantProductSummary (
  VARIANT_PRODUCT_ID           NUMERIC(12) not null,
  TRANSCRIPT_NA_FEATURE_ID     varchar(20), /* references dots.NaFeatureImp */
  CODON                        varchar(3),
  POSITION_IN_CODON            NUMERIC(1),
  COUNT                        NUMERIC(5),
  PRODUCT                      varchar(1),
  REF_LOCATION_CDS             varchar(2500),
  REF_LOCATION_PROTEIN         varchar(2500),
  modification_date            timestamp,
  USER_READ                    NUMERIC(1),
  USER_WRITE                   NUMERIC(1),
  GROUP_READ                   NUMERIC(1),
  GROUP_WRITE                  NUMERIC(1),
  OTHER_READ                   NUMERIC(1),
  OTHER_WRITE                  NUMERIC(1),
  ROW_USER_ID                  NUMERIC(12),
  ROW_GROUP_ID                 NUMERIC(3),
  ROW_PROJECT_ID               NUMERIC(4),
  ROW_ALG_INVOCATION_ID        NUMERIC(12),
  PRIMARY KEY (variant_product_id)
);

create sequence apidb.VariantProductSummary_sq;

grant select on apidb.variantproductsummary to gus_r;
grant insert, select, update, delete on apidb.variantproductsummary to gus_w;
grant select ON apidb.variantproductsummary_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'VariantProductSummary', 'Standard', 'variant_product_id',
    d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
    p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'VariantProductSummary' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);

--------------------------------------------------------------------------------

create table apidb.VariantAlleleSummary (
  VARIANT_ALLELE_ID            NUMERIC(12) not null,
  ALLELE                       varchar(10) not null,
  DISTINCT_STRAIN_COUNT        NUMERIC(3),
  ALLELE_COUNT                 NUMERIC(3),
  AVERAGE_COVERAGE             decimal(10,2),
  AVERAGE_READ_PERCENT         decimal(10,2),
  modification_date            timestamp,
  USER_READ                    NUMERIC(1),
  USER_WRITE                   NUMERIC(1),
  GROUP_READ                   NUMERIC(1),
  GROUP_WRITE                  NUMERIC(1),
  OTHER_READ                   NUMERIC(1),
  OTHER_WRITE                  NUMERIC(1),
  ROW_USER_ID                  NUMERIC(12),
  ROW_GROUP_ID                 NUMERIC(3),
  ROW_PROJECT_ID               NUMERIC(4),
  ROW_ALG_INVOCATION_ID        NUMERIC(12),
  PRIMARY KEY (variant_allele_id)
);

create sequence apidb.VariantAlleleSummary_sq;

grant select on apidb.variantallelesummary to gus_r;
grant insert, select, update, delete on apidb.variantallelesummary to gus_w;
grant select ON apidb.variantallelesummary_sq TO gus_w;

INSERT INTO core.TableInfo
  (table_id, name, table_type, primary_key_column, database_id,
    is_versioned, is_view, view_on_table_id, superclass_table_id, is_updatable,
    modification_date, user_read, user_write, group_read, group_write,
    other_read, other_write, row_user_id, row_group_id, row_project_id,
    row_alg_invocation_id)
  SELECT nextval('core.tableinfo_sq'), 'VariantAlleleSummary', 'Standard', 'variant_allele_id',
    d.database_id, 0, 0, NULL, NULL, 1, localtimestamp, 1, 1, 1, 1, 1, 1, 1, 1,
    p.project_id, 0
  FROM
       (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
       (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
  WHERE 'VariantAlleleSummary' NOT IN (SELECT name FROM core.TableInfo
  WHERE database_id = d.database_id);

exit;
