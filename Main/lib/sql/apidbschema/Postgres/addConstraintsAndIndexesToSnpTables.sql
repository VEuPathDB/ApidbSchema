ALTER TABLE apidb.snp
ADD FOREIGN KEY (gene_na_feature_id) REFERENCES dots.NaFeatureImp(na_feature_id);
ALTER TABLE apidb.snp
ADD FOREIGN KEY (na_sequence_id) REFERENCES dots.NaSequenceImp(na_sequence_id);
ALTER TABLE apidb.snp
ADD FOREIGN KEY (external_database_release_id) REFERENCES sres.ExternalDatabaseRelease(external_database_release_id);

ALTER TABLE apidb.snp
ADD UNIQUE (source_id);

ALTER TABLE apidb.snp
ADD UNIQUE (na_sequence_id, location);

CREATE INDEX SnpLocIx
  ON apidb.Snp(na_sequence_id, location, source_id, snp_id, gene_na_feature_id);

CREATE INDEX SnpSrcIx
  ON apidb.Snp(source_id, na_sequence_id, location, snp_id, gene_na_feature_id);

CREATE INDEX SnpIdIx
  ON apidb.Snp(snp_id, na_sequence_id, location, source_id, gene_na_feature_id);

CREATE INDEX SnpNASeqLocIx
  ON apidb.Snp(location, na_sequence_id);

CREATE INDEX SnpFeatIx
  ON apidb.Snp(gene_na_feature_id, snp_id, na_sequence_id, location, source_id);

CREATE INDEX Snp_revfk_ix
  ON apidb.Snp(external_database_release_id, na_sequence_id, location)
;
----------------------------------------------------------------

ALTER TABLE apidb.sequencevariation
ADD FOREIGN KEY (external_database_release_id) REFERENCES sres.ExternalDatabaseRelease(external_database_release_id);
ALTER TABLE apidb.sequencevariation
ADD FOREIGN KEY (snp_ext_db_rls_id) REFERENCES sres.ExternalDatabaseRelease(external_database_release_id);
ALTER TABLE apidb.sequencevariation
ADD FOREIGN KEY (ref_na_sequence_id, location) REFERENCES apidb.Snp(na_sequence_id, location);
ALTER TABLE apidb.sequencevariation
ADD FOREIGN KEY (protocol_app_node_id) REFERENCES study.protocolappnode(protocol_app_node_id);


CREATE INDEX SnpVarNASeqLocIx
  ON apidb.SequenceVariation(ref_na_sequence_id, location)
;

CREATE INDEX SeqVarRevFkIx1
  ON apidb.SequenceVariation(external_database_release_id, sequence_variation_id)
;

CREATE INDEX SeqVarRevFkIx3
  ON apidb.SequenceVariation(protocol_app_node_id, sequence_variation_id)
;

CREATE INDEX SeqVarRevFkIx2
  ON apidb.SequenceVariation(snp_ext_db_rls_id, sequence_variation_id)
;

CREATE INDEX SeqDateIx
  ON apidb.SequenceVariation(modification_date, sequence_variation_id)
;

