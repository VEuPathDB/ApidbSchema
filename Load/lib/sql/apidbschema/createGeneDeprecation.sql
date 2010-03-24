CREATE TABLE ApiDB.GeneDeprecation (
 source_id     VARCHAR2(30) NOT NULL,
 action        VARCHAR2(10) NOT NULL,
 action_date   DATE NOT NULL
);

GRANT insert, select, update, delete ON ApiDB.GeneDeprecation TO gus_w;
GRANT select ON ApiDB.GeneDeprecation TO gus_r;
GRANT select ON ApiDB.GeneDeprecation TO gus_w;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'GeneDeprecation',
       'Standard', '',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE name = 'ApiDB') d
WHERE 'GeneDeprecation' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);
exit;

