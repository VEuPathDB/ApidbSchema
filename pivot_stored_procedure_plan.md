# Plan: Translate Oracle `createPivotProcedure.sql` to PostgreSQL

## Summary

Translate the Oracle dynamic pivot function (`apidb.pivot`) to a PostgreSQL equivalent. The Oracle version uses ODCI (Data Cartridge Interface) to return dynamic column sets at runtime — PostgreSQL has no equivalent framework, so we use a **refcursor-based approach** that dynamically constructs and executes the pivot query.

## File Modified

- `Main/lib/sql/apidbschema/Postgres/createPivotProcedure.sql`

## Design Approach: Refcursor with Dynamic SQL

The Oracle `pivot()` function:
1. Takes a query where columns 1..N-2 are group-by cols, col N-1 is the pivot col, col N is the value col
2. Finds distinct values of the pivot column
3. Builds `SELECT group_cols, MAX(DECODE(pivot_col, 'val1', value_col)) ... GROUP BY group_cols`
4. Returns the dynamic result set

**PostgreSQL translation** — a PL/pgSQL function that:
1. Accepts the same parameters (`p_stmt text`, `p_fmt text DEFAULT 'upper(@p@)'`)
2. Parses column metadata from the query using a temp table and `pg_attribute`
3. Queries for distinct pivot values (applying the format string)
4. Constructs a dynamic SQL query using `MAX(CASE WHEN ... THEN ... END)` (PostgreSQL equivalent of Oracle's `DECODE`)
5. Returns a **refcursor** — the most faithful equivalent since it allows dynamic column structures without requiring the caller to pre-declare column types

### Function Signature

```sql
CREATE OR REPLACE FUNCTION apidb.pivot(
    p_stmt text,
    p_fmt  text DEFAULT 'upper(@p@)'
) RETURNS refcursor
```

### Implementation Logic

1. Create a temp table with `LIMIT 0` to introspect column names via `pg_attribute`
2. Identify:
   - Group-by columns: columns 1 through N-2
   - Pivot column: column N-1
   - Value column: column N
3. Build a query for distinct pivot values: `SELECT DISTINCT <fmt(pivot_col)>::text FROM (<p_stmt>) sub ORDER BY 1`
4. For each distinct value, append: `MAX(CASE WHEN <fmt(pivot_col)>::text = '<value>' THEN <value_col> END) AS "<value>"`
5. Combine into: `SELECT <group_cols>, <pivot_aggregates> FROM (<p_stmt>) sub GROUP BY <group_cols>`
6. Open and return a refcursor for the dynamic query

### Grants

```sql
GRANT EXECUTE ON FUNCTION apidb.pivot(text, text) TO gus_r;
GRANT EXECUTE ON FUNCTION apidb.pivot(text, text) TO gus_w;
```

## Usage

Since the function returns a refcursor, it requires a transaction with FETCH:

```sql
BEGIN;
SELECT apidb.pivot(
  'SELECT project_name, core_peripheral, abbrev FROM apidb.organism'
) AS cursor_name;
FETCH ALL FROM "<unnamed portal 2>";
COMMIT;
```

## Why Not crosstab?

Although `tablefunc`/`crosstab` is available, it requires the caller to declare the output column types in the `FROM` clause, e.g.:
```sql
SELECT * FROM crosstab(...) AS ct(row_name text, col1 int, col2 int, ...);
```
This defeats the purpose of a dynamic pivot where column names aren't known until runtime. The refcursor approach preserves the Oracle version's fully dynamic behavior.

## PostgreSQL Limitations vs Oracle

PostgreSQL cannot return truly dynamic column sets from a function in a single `SELECT *` call. Oracle's ODCI framework is unique in allowing this. Alternatives considered:

1. **Refcursor (chosen)**: Dynamic columns, but requires `FETCH` in a transaction block
2. **Temp table**: Function writes to a temp table, caller queries it separately — two statements but plain SQL
3. **SETOF record**: Single query, but caller must declare column types in the FROM clause
4. **JSONB rows**: Single query with dynamic keys, but values are inside JSON objects rather than real columns

## Verification (Tested Successfully)

1. Installed the function on `unidb_shu_a` database — `CREATE FUNCTION` and both `GRANT` statements succeeded
2. Tested with `apidb.organism` table — pivoted `core_peripheral` values into `CORE` and `PERIPHERAL` columns grouped by `project_name`, with `abbrev` as cell values
3. Tested with a custom `person_props` table — pivoted `property` column (`weight`, `height`, `hair_color`) into columns grouped by `person_id`
