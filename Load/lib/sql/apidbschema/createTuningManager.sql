create table apidb.TuningDefinition (
   name       varchar2(65) primary key,
   timestamp  date not null,
   definition clob not null);

create table apidb.ObsoletedTuningTables (
   name       varchar2(65) primary key,
   timestamp  date not null);

create sequence apidb.TuningManager_sq
   start with 1111;
