CREATE SCHEMA chebi;

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
  id                  numeric             primary key,
  name                text            ,
  source              varchar(32)     not null,
  parent_id           numeric             ,
  chebi_accession     varchar(30)     not null,
  status              varchar(1)      not null,
  definition          text	    ,
  star                int             ,
  modified_on         text            ,
  created_by          text,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp
) without oids;


--
-- Table chemical_data
--

CREATE TABLE chebi.chemical_data (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  chemical_data       text            not null,
  source              text            not null,
  type                text            not null,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp

) without oids;

create index chemical_data_compound_id_idx on chebi.chemical_data(compound_id);


--
-- Table comments
--

CREATE TABLE chebi.comments (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  text                text            not null,
  created_on          timestamp(0)    not null,
  datatype            varchar(80)     ,
  datatype_id         numeric             not null,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp
) without oids;

create index comments_compound_id_idx on chebi.comments(compound_id);



--
-- Table database_accession
--

CREATE TABLE chebi.database_accession (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  accession_number    varchar(255)    not null,
  type                text            not null,
  source              text            not null,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp
) without oids;

create index database_accession_compound_id_idx on chebi.database_accession(compound_id);


--
-- Table names
--

CREATE TABLE chebi.names (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  name                text            not null,
  type                text            not null,
  source              text            not null,
  adapted             text            not null,
  language            text            not null,
  MODIFICATION_DATE   timestamp       DEFAULT localtimestamp

) without oids;

create index names_compound_id_idx on chebi.names(compound_id);


--
-- Table reference
--

CREATE TABLE chebi.reference (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  reference_id        varchar(60)     not null,
  reference_db_name   varchar(60)     not null,
  location_in_ref     varchar(90)             ,
  reference_name      varchar(1024),
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp

) without oids;

create index reference_compound_id_idx on chebi.reference(compound_id);

--
-- Table relation
--

CREATE TABLE chebi.relation (
  id                  numeric             primary key,
  type                text            not null,
  init_id             numeric             not null
    references chebi.compounds(id),
  final_id            numeric             not null
    references chebi.compounds(id),
  status              varchar(1)      not null,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp,
    unique (type,init_id,final_id)
) without oids;

create index relation_init_id_idx on chebi.relation(init_id);
create index relation_final_id_idx on chebi.relation(final_id);

--
-- Table structures
--

CREATE TABLE chebi.structures (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  structure           text            not null,
  type                text            not null,
  dimension           text            not null,
  default_structure   varchar(1)      not null,
  autogen_structure   varchar(1)      not null,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp
) without oids;

create index structures_compound_id_idx on chebi.structures(compound_id);



--
-- Table compound_origins
--

CREATE TABLE chebi.compound_origins (
  id                  numeric             primary key,
  compound_id         numeric             not null
    references chebi.compounds(id)
      on delete cascade,
  species_text        text            not null,
  species_accession   text                    ,
  component_text      text                    ,
  component_accession  text                    ,
  strain_text         text                    ,
  source_type         text            not null,
  source_accession    text            not null,
  comments            text,
  MODIFICATION_DATE   timestamp DEFAULT localtimestamp

) without oids;

create index compound_origins_id_idx on chebi.compound_origins(compound_id);

