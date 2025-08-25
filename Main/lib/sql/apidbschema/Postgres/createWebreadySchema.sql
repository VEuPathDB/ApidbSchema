CREATE SCHEMA webready;

GRANT USAGE ON SCHEMA webready TO gus_r;
GRANT USAGE, CREATE ON SCHEMA webready TO gus_w;

ALTER DEFAULT PRIVILEGES IN SCHEMA webready GRANT SELECT ON TABLES TO gus_r;

INSERT INTO core.DatabaseInfo
   (database_id, name, description, modification_date, user_read, user_write,
    group_read, group_write, other_read, other_write, row_user_id,
    row_group_id, row_project_id, row_alg_invocation_id)
SELECT NEXTVAL('core.databaseinfo_sq'), 'Webready',
       'Denormalized webready tables for the websites created by the workflow', localtimestamp,
       1, 1, 1, 1, 1, 1, 1, 1, p.project_id, 0
FROM (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p
WHERE lower('webready') NOT IN (SELECT lower(name) FROM core.DatabaseInfo);
