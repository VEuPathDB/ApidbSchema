DROP VIEW rad.ExpressionProfile;

CREATE VIEW rad.ExpressionProfile AS
SELECT
   analysis_result_id,
   subclass_view,
   analysis_id,
   table_id,
   row_id,
   float1 as mean,
   float2 as std_err,
   float3 as std_dev,
   float4 as percentile,
   modification_date,
   user_read,
   user_write,
   group_read,
   group_write,
   other_read,
   other_write,
   row_user_id,
   row_group_id,
   row_project_id,
   row_alg_invocation_id
FROM RAD.AnalysisResultImp
WHERE subclass_view = 'ExpressionProfile'
WITH CHECK OPTION;

GRANT INSERT, SELECT, UPDATE, DELETE ON rad.ExpressionProfile TO gus_w;
GRANT SELECT ON rad.ExpressionProfile TO gus_r;

------------------------------------------------------------------------------

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'ExpressionProfile',
       'Standard', 'ANALYSIS_RESULT_ID',
       d.database_id, 0, 1, t.table_id, s.table_id, 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'rad') d,
     (SELECT table_id FROM core.TableInfo WHERE name = 'AnalysisResultImp') t,
     (SELECT table_id FROM core.TableInfo WHERE name = 'AnalysisResult') s
WHERE 'ExpressionProfile' NOT IN (SELECT name FROM core.TableInfo
                                    WHERE database_id = d.database_id);

------------------------------------------------------------------------------
exit;