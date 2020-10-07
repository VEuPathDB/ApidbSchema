CREATE TABLE apidb.PropertyGraph (
 property_graph_id            NUMBER(12) NOT NULL,
 name                         VARCHAR2(200) NOT NULL,
 external_database_release_id number(10) NOT NULL,
 modification_date            DATE NOT NULL,
 user_read                    NUMBER(1) NOT NULL,
 user_write                   NUMBER(1) NOT NULL,
 group_read                   NUMBER(1) NOT NULL,
 group_write                  NUMBER(1) NOT NULL,
 other_read                   NUMBER(1) NOT NULL,
 other_write                  NUMBER(1) NOT NULL,
 row_user_id                  NUMBER(12) NOT NULL,
 row_group_id                 NUMBER(3) NOT NULL,
 row_project_id               NUMBER(4) NOT NULL,
 row_alg_invocation_id        NUMBER(12) NOT NULL,
 FOREIGN KEY (external_database_release_id) REFERENCES sres.ExternalDatabaseRelease,
 PRIMARY KEY (property_graph_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.PropertyGraph TO gus_w;
GRANT SELECT ON apidb.PropertyGraph TO gus_r;

CREATE SEQUENCE apidb.PropertyGraph_sq;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'PropertyGraph',
       'Standard', 'property_graph_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'propertygraph' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

-----------------------------------------------------------


CREATE TABLE apidb.EdgeLabel (
 edge_label_id            NUMBER(12) NOT NULL,
 name                         VARCHAR2(200) NOT NULL,
 description                  VARCHAR2(4000) NULL,
 modification_date            DATE NOT NULL,
 user_read                    NUMBER(1) NOT NULL,
 user_write                   NUMBER(1) NOT NULL,
 group_read                   NUMBER(1) NOT NULL,
 group_write                  NUMBER(1) NOT NULL,
 other_read                   NUMBER(1) NOT NULL,
 other_write                  NUMBER(1) NOT NULL,
 row_user_id                  NUMBER(12) NOT NULL,
 row_group_id                 NUMBER(3) NOT NULL,
 row_project_id               NUMBER(4) NOT NULL,
 row_alg_invocation_id        NUMBER(12) NOT NULL,
 PRIMARY KEY (edge_label_id)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.EdgeLabel TO gus_w;
GRANT SELECT ON apidb.EdgeLabel TO gus_r;

CREATE SEQUENCE apidb.EdgeLabel_sq;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'EdgeLabel',
       'Standard', 'edge_label_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'edgelabel' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

-----------------------------------------------------------


CREATE TABLE apidb.VertexAttributes (
 vertex_attributes_id         NUMBER(12) NOT NULL,
 name                         VARCHAR2(200) NOT NULL,
 pan_type                     VARCHAR2(50) NOT NULL,
 isa_type                     VARCHAR2(50) NOT NULL, 
 property_graph_id            NUMBER(12) NOT NULL,
 atts                         CLOB,
 modification_date            DATE NOT NULL,
 user_read                    NUMBER(1) NOT NULL,
 user_write                   NUMBER(1) NOT NULL,
 group_read                   NUMBER(1) NOT NULL,
 group_write                  NUMBER(1) NOT NULL,
 other_read                   NUMBER(1) NOT NULL,
 other_write                  NUMBER(1) NOT NULL,
 row_user_id                  NUMBER(12) NOT NULL,
 row_group_id                 NUMBER(3) NOT NULL,
 row_project_id               NUMBER(4) NOT NULL,
 row_alg_invocation_id        NUMBER(12) NOT NULL,
 FOREIGN KEY (property_graph_id) REFERENCES apidb.propertygraph,
 PRIMARY KEY (vertex_attributes_id),
 CONSTRAINT ensure_va_json CHECK (atts is json)   
);

CREATE SEARCH INDEX apidb.va_search_idx ON apidb.vertexattributes (atts) FOR JSON;

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.VertexAttributes TO gus_w;
GRANT SELECT ON apidb.VertexAttributes TO gus_r;

CREATE SEQUENCE apidb.VertexAttributes_sq;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'VertexAttributes',
       'Standard', 'vertex_attributes_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'vertexattributes' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);

-----------------------------------------------------------

CREATE TABLE apidb.EdgeAttributes (
 edge_attributes_id           NUMBER(12) NOT NULL,
 edge_label_id                NUMBER(12) NOT NULL,
 in_vertex_id                 NUMBER(12) NOT NULL,
 out_vertex_id                NUMBER(12) NOT NULL,
 atts                         CLOB,
 modification_date            DATE NOT NULL,
 user_read                    NUMBER(1) NOT NULL,
 user_write                   NUMBER(1) NOT NULL,
 group_read                   NUMBER(1) NOT NULL,
 group_write                  NUMBER(1) NOT NULL,
 other_read                   NUMBER(1) NOT NULL,
 other_write                  NUMBER(1) NOT NULL,
 row_user_id                  NUMBER(12) NOT NULL,
 row_group_id                 NUMBER(3) NOT NULL,
 row_project_id               NUMBER(4) NOT NULL,
 row_alg_invocation_id        NUMBER(12) NOT NULL,
 FOREIGN KEY (in_vertex_id) REFERENCES apidb.vertexattributes,
 FOREIGN KEY (out_vertex_id) REFERENCES apidb.vertexattributes,
 FOREIGN KEY (edge_label_id) REFERENCES apidb.edgelabel,
 PRIMARY KEY (edge_attributes_id),
 CONSTRAINT ensure_ea_json CHECK (atts is json)   
);

CREATE INDEX apidb.ea_in_idx ON apidb.edgeattributes (in_vertex_id, out_vertex_id) tablespace indx;
CREATE INDEX apidb.ea_out_idx ON apidb.edgeattributes (out_vertex_id, in_vertex_id) tablespace indx;

GRANT INSERT, SELECT, UPDATE, DELETE ON apidb.EdgeAttributes TO gus_w;
GRANT SELECT ON apidb.EdgeAttributes TO gus_r;

CREATE SEQUENCE apidb.EdgeAttributes_sq;

INSERT INTO core.TableInfo
    (table_id, name, table_type, primary_key_column, database_id, is_versioned,
     is_view, view_on_table_id, superclass_table_id, is_updatable, 
     modification_date, user_read, user_write, group_read, group_write, 
     other_read, other_write, row_user_id, row_group_id, row_project_id, 
     row_alg_invocation_id)
SELECT core.tableinfo_sq.nextval, 'EdgeAttributes',
       'Standard', 'edge_attributes_id',
       d.database_id, 0, 0, '', '', 1,sysdate, 1, 1, 1, 1, 1, 1, 1, 1,
       p.project_id, 0
FROM dual,
     (SELECT MAX(project_id) AS project_id FROM core.ProjectInfo) p,
     (SELECT database_id FROM core.DatabaseInfo WHERE lower(name) = 'apidb') d
WHERE 'edgeattributes' NOT IN (SELECT lower(name) FROM core.TableInfo
                                    WHERE database_id = d.database_id);


exit;
