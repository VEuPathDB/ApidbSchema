CREATE SCHEMA chebi;

GRANT USAGE ON SCHEMA chebi TO gus_r;

INSERT INTO core.DatabaseInfo
   (database_id, name, description, modification_date, user_read, user_write,
    group_read, group_write, other_read, other_write, row_user_id,
    row_group_id, row_project_id, row_alg_invocation_id)
SELECT NEXTVAL('core.databaseinfo_sq'), 'chEBI',
       'Application-specific data for the chEBI data', localtimestamp,
       1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p
WHERE lower('chEBI') NOT IN (SELECT lower(name) FROM core.DatabaseInfo);



--
-- pgsql_create_tables.sql
-- PostgreSQL create table script for importing ChEBI database.
-- With thanks to: Anne Morgat @ (SIB)
--

--
-- Table compounds
--

CREATE TABLE chebi.compounds (
  id                NUMERIC PRIMARY KEY,
  name              TEXT,
  source            VARCHAR(32) NOT NULL,
  parent_id         NUMERIC,
  chebi_accession   VARCHAR(30) NOT NULL,
  status            VARCHAR(1)  NOT NULL,
  definition        TEXT,
  star              INT,
  modified_on       TEXT,
  created_by        TEXT,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;


--
-- Table chemical_data
--

CREATE TABLE chebi.chemical_data (
  id                NUMERIC PRIMARY KEY,
  compound_id       NUMERIC NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  chemical_data     TEXT    NOT NULL,
  source            TEXT    NOT NULL,
  type              TEXT    NOT NULL,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX chemical_data_compound_id_idx ON chebi.chemical_data(compound_id);


--
-- Table comments
--

CREATE TABLE chebi.comments (
  id                NUMERIC PRIMARY KEY,
  compound_id       NUMERIC      NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  text              TEXT         NOT NULL,
  created_on        TIMESTAMP(0) NOT NULL,
  datatype          VARCHAR(80),
  datatype_id       NUMERIC      NOT NULL,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX comments_compound_id_idx ON chebi.comments(compound_id);



--
-- Table database_accession
--

CREATE TABLE chebi.database_accession (
  id                NUMERIC PRIMARY KEY,
  compound_id       NUMERIC      NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  accession_number  VARCHAR(255) NOT NULL,
  type              TEXT         NOT NULL,
  source            TEXT         NOT NULL,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX database_accession_compound_id_idx ON chebi.database_accession(compound_id);


--
-- Table names
--

CREATE TABLE chebi.names (
  id                NUMERIC PRIMARY KEY,
  compound_id       NUMERIC NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  name              TEXT    NOT NULL,
  type              TEXT    NOT NULL,
  source            TEXT    NOT NULL,
  adapted           TEXT    NOT NULL,
  language          TEXT    NOT NULL,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX names_compound_id_idx ON chebi.names(compound_id);


--
-- Table reference
--

CREATE TABLE chebi.reference (
  id                NUMERIC PRIMARY KEY,
  compound_id       NUMERIC     NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  reference_id      VARCHAR(60) NOT NULL,
  reference_db_name VARCHAR(60) NOT NULL,
  location_in_ref   VARCHAR(90),
  reference_name    VARCHAR(1024),
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX reference_compound_id_idx ON chebi.reference(compound_id);

--
-- Table relation
--

CREATE TABLE chebi.relation (
  id                NUMERIC PRIMARY KEY,
  type              TEXT       NOT NULL,
  init_id           NUMERIC    NOT NULL
    REFERENCES chebi.compounds(id),
  final_id          NUMERIC    NOT NULL
    REFERENCES chebi.compounds(id),
  status            VARCHAR(1) NOT NULL,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp,
  UNIQUE (type, init_id, final_id)
)
  WITHOUT OIDS;

CREATE INDEX relation_init_id_idx ON chebi.relation(init_id);
CREATE INDEX relation_final_id_idx ON chebi.relation(final_id);

--
-- Table structures
--

CREATE TABLE chebi.structures (
  id                NUMERIC PRIMARY KEY,
  compound_id       NUMERIC    NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  structure         TEXT       NOT NULL,
  type              TEXT       NOT NULL,
  dimension         TEXT       NOT NULL,
  default_structure VARCHAR(1) NOT NULL,
  autogen_structure VARCHAR(1) NOT NULL,
  MODIFICATION_DATE TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX structures_compound_id_idx ON chebi.structures(compound_id);



--
-- Table compound_origins
--

CREATE TABLE chebi.compound_origins (
  id                  NUMERIC PRIMARY KEY,
  compound_id         NUMERIC NOT NULL
    REFERENCES chebi.compounds(id)
      ON DELETE CASCADE,
  species_text        TEXT    NOT NULL,
  species_accession   TEXT,
  component_text      TEXT,
  component_accession TEXT,
  strain_text         TEXT,
  source_type         TEXT    NOT NULL,
  source_accession    TEXT    NOT NULL,
  comments            TEXT,
  MODIFICATION_DATE   TIMESTAMP DEFAULT localtimestamp
)
  WITHOUT OIDS;

CREATE INDEX compound_origins_id_idx ON chebi.compound_origins(compound_id);

