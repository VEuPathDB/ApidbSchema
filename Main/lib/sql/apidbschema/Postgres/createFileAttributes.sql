CREATE TABLE apidb.FileAttributes (
  file_id     varchar(100),
  filename    varchar(200),
  filepath    varchar(250),
  organism    varchar(100),
  build_num   numeric(3),
  category    varchar(50),
  file_type   varchar(50),
  file_format varchar(20),
  filesize    numeric(10),
  checksum    varchar(100),
  PRIMARY KEY (file_id)
);

GRANT SELECT ON apidb.FileAttributes TO gus_r;
GRANT INSERT, UPDATE, DELETE ON apidb.FileAttributes TO gus_w;
