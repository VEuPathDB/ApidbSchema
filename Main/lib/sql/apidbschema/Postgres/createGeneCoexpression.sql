CREATE SEQUENCE ApiDB.GeneCoexpression_sq;

GRANT select ON ApiDB.GeneCoexpression_sq TO gus_r;
GRANT select ON ApiDB.GeneCoexpression_sq TO gus_w;


CREATE TABLE ApiDB.GeneCoexpression (
  gene_coexpression_id           NUMERIC(10)   NOT NULL  DEFAULT nextval('apidb.GeneCoexpression_sq'),
  gene_id                        VARCHAR(50)   NOT NULL,
  associated_gene_id             VARCHAR(50)   NOT NULL,
  coefficient                    FLOAT8,
  external_database_release_id   NUMERIC(10)   NOT NULL,
  FOREIGN KEY (external_database_release_id)
    REFERENCES sres.ExternalDatabaseRelease (external_database_release_id),
  PRIMARY KEY (gene_coexpression_id)
);

GRANT insert, select, update, delete ON ApiDB.GeneCoexpression TO gus_w;
GRANT select ON ApiDB.GeneCoexpression TO gus_r;


-- Indexes: the PK auto-indexes gene_coexpression_id. Index gene_id (per-gene
-- coexpression lookups), associated_gene_id (reverse lookups), and
-- external_database_release_id (used by reload deletes).
CREATE INDEX genecoexpression_gene_ix
  ON ApiDB.GeneCoexpression (gene_id);
CREATE INDEX genecoexpression_assoc_gene_ix
  ON ApiDB.GeneCoexpression (associated_gene_id);
CREATE INDEX genecoexpression_extdbrls_ix
  ON ApiDB.GeneCoexpression (external_database_release_id);
