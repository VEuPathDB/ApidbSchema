---------ApiDB.VariationFeature ----------------------------
------------------------------------------------------------
CREATE TABLE ApiDB.VariationFeature (
  source_id                       VARCHAR(100)  NOT NULL,
  sequence_source_id              VARCHAR(60)   NOT NULL,
  location                        NUMERIC(12)   NOT NULL,
  reference_strain                VARCHAR(100)  NOT NULL,
  is_coding                       NUMERIC(1)    NOT NULL,
  variant_type                    VARCHAR(10)   NOT NULL,
  distinct_strain_count           NUMERIC(6),
  called_strain_count             NUMERIC(6),
  no_call_strain_count            NUMERIC(6),
  call_rate                       FLOAT,
  total_ploidy_count              NUMERIC(8),
  ref_allele_frequency            FLOAT,
  het_strain_count                NUMERIC(6),
  snp_ref_allele                  VARCHAR(1),
  snp_major_allele                VARCHAR(1),
  snp_major_allele_frequency      FLOAT,
  snp_major_allele_strain_count   NUMERIC(6),
  snp_minor_allele                VARCHAR(1),
  snp_minor_allele_frequency      FLOAT,
  snp_minor_allele_strain_count   NUMERIC(6),
  snp_major_genomic_hgvs          VARCHAR(500),
  snp_minor_genomic_hgvs          VARCHAR(500),
  indel_ref_allele                VARCHAR(1000),
  indel_major_allele              VARCHAR(1000),
  indel_major_allele_frequency    FLOAT,
  indel_major_allele_strain_count NUMERIC(6),
  indel_minor_allele              VARCHAR(1000),
  indel_minor_allele_frequency    FLOAT,
  indel_minor_allele_strain_count NUMERIC(6),
  indel_major_genomic_hgvs        VARCHAR(500),
  indel_minor_genomic_hgvs        VARCHAR(500),
  indel_frame_effect              VARCHAR(20),
  external_database_release_id    NUMERIC(10)   NOT NULL,
  PRIMARY KEY (sequence_source_id, location),
  FOREIGN KEY (external_database_release_id) REFERENCES sres.ExternalDatabaseRelease (external_database_release_id),
  UNIQUE (source_id)
);

GRANT SELECT ON ApiDB.VariationFeature TO gus_r;
GRANT INSERT, UPDATE, DELETE ON ApiDB.VariationFeature TO gus_w;

CREATE INDEX variationfeature_extdbrls_ix ON ApiDB.VariationFeature (external_database_release_id);

---------ApiDB.VariationTranscriptProduct ------------------
------------------------------------------------------------

CREATE TABLE ApiDB.VariationTranscriptProduct (
  sequence_source_id                  VARCHAR(60)   NOT NULL,
  location                            NUMERIC(12)   NOT NULL,
  na_feature_id                       NUMERIC(10)   NOT NULL,
  pos_in_cds                          NUMERIC(12),
  pos_in_protein                      NUMERIC(12),
  codon                               VARCHAR(3),
  pos_in_codon                        NUMERIC(1),
  strain_count                        NUMERIC(6),
  product                             VARCHAR(1),
  matches_ref_codon                   NUMERIC(1),
  matches_ref_product                 NUMERIC(1),
  hgvs_p                              VARCHAR(500),
  FOREIGN KEY (sequence_source_id, location) REFERENCES ApiDB.VariationFeature (sequence_source_id, location) ON DELETE CASCADE,
  FOREIGN KEY (na_feature_id) REFERENCES dots.NaFeatureImp (na_feature_id)
);

GRANT SELECT ON ApiDB.VariationTranscriptProduct TO gus_r;
GRANT INSERT, UPDATE, DELETE ON ApiDB.VariationTranscriptProduct TO gus_w;

CREATE INDEX variationtranscriptproduct_loc_ix ON ApiDB.VariationTranscriptProduct (sequence_source_id, location);
CREATE INDEX variationtranscriptproduct_naf_ix ON ApiDB.VariationTranscriptProduct (na_feature_id);

---------ApiDB.VariationEffect -----------------------------
------------------------------------------------------------

CREATE TABLE ApiDB.VariationEffect (
  sequence_source_id   VARCHAR(60)   NOT NULL,
  location             NUMERIC(12)   NOT NULL,
  allele               VARCHAR(1000),
  na_feature_id        NUMERIC(10),
  impact               VARCHAR(20),
  effect               VARCHAR(60),
  hgvs_c               VARCHAR(500),
  source               VARCHAR(20),
  FOREIGN KEY (sequence_source_id, location) REFERENCES ApiDB.VariationFeature (sequence_source_id, location) ON DELETE CASCADE,
  FOREIGN KEY (na_feature_id) REFERENCES dots.NaFeatureImp (na_feature_id)
);

GRANT SELECT ON ApiDB.VariationEffect TO gus_r;
GRANT INSERT, UPDATE, DELETE ON ApiDB.VariationEffect TO gus_w;


CREATE INDEX variationeffect_loc_ix ON ApiDB.VariationEffect (sequence_source_id, location);
CREATE INDEX variationeffect_naf_ix ON ApiDB.VariationEffect (na_feature_id);

