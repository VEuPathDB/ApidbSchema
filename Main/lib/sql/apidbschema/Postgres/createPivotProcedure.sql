CREATE OR REPLACE FUNCTION apidb.pivot(
    p_stmt text,
    p_fmt  text DEFAULT 'upper(@p@)'
) RETURNS refcursor
LANGUAGE plpgsql
AS $$
DECLARE
    v_ref      refcursor;
    v_fmt      text;
    v_numcols  integer;
    v_col_names text[];
    v_pivot_col text;
    v_value_col text;
    v_group_cols text := '';
    v_pivot_expr text := '';
    v_sql      text;
    v_distinct_sql text;
    v_rec      record;
BEGIN
    -- Validate format string contains the placeholder
    IF position('@p@' in p_fmt) > 0 THEN
        v_fmt := p_fmt;
    ELSE
        v_fmt := '@p@';
    END IF;

    -- Create temp table to introspect query columns
    DROP TABLE IF EXISTS _pivot_meta;
    EXECUTE 'CREATE TEMP TABLE _pivot_meta AS SELECT * FROM ('
            || p_stmt || ') _sub LIMIT 0';

    -- Get column names in ordinal order
    SELECT array_agg(attname::text ORDER BY attnum)
      INTO v_col_names
      FROM pg_attribute
     WHERE attrelid = '_pivot_meta'::regclass
       AND attnum > 0
       AND NOT attisdropped;

    v_numcols := array_length(v_col_names, 1);

    DROP TABLE _pivot_meta;

    -- Identify pivot column (N-1) and value column (N)
    v_pivot_col := v_col_names[v_numcols - 1];
    v_value_col := v_col_names[v_numcols];

    -- Build group-by column list (columns 1 .. N-2)
    FOR i IN 1 .. v_numcols - 2 LOOP
        IF i > 1 THEN
            v_group_cols := v_group_cols || ', ';
        END IF;
        v_group_cols := v_group_cols || quote_ident(v_col_names[i]);
    END LOOP;

    -- Query distinct pivot values and build CASE expressions
    v_distinct_sql := 'SELECT DISTINCT '
        || replace(v_fmt, '@p@', quote_ident(v_pivot_col))
        || '::text AS pval FROM (' || p_stmt || ') _sub ORDER BY 1';

    FOR v_rec IN EXECUTE v_distinct_sql LOOP
        v_pivot_expr := v_pivot_expr
            || ', MAX(CASE WHEN '
            || replace(v_fmt, '@p@', quote_ident(v_pivot_col))
            || '::text = ' || quote_literal(v_rec.pval)
            || ' THEN ' || quote_ident(v_value_col)
            || ' END) AS ' || quote_ident(v_rec.pval);
    END LOOP;

    -- Build final SELECT
    IF v_group_cols = '' THEN
        v_sql := 'SELECT ' || substr(v_pivot_expr, 3)
              || ' FROM (' || p_stmt || ') _sub';
    ELSE
        v_sql := 'SELECT ' || v_group_cols || v_pivot_expr
              || ' FROM (' || p_stmt || ') _sub'
              || ' GROUP BY ' || v_group_cols;
    END IF;

    -- Open and return a refcursor with the dynamic result
    OPEN v_ref FOR EXECUTE v_sql;
    RETURN v_ref;
END;
$$;

GRANT EXECUTE ON FUNCTION apidb.pivot(text, text) TO gus_r;
GRANT EXECUTE ON FUNCTION apidb.pivot(text, text) TO gus_w;
