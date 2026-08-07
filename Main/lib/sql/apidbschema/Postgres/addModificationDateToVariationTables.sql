-- Patch for databases created before modification_date was added to the
-- variation tables. New installs get it from createVariationTables.sql; this
-- script brings an existing instance to the same state and is idempotent, so it
-- is safe to re-run.
--
-- Why: TuningManager detects change in tables declared as <externalDependency>
-- (apiTuningManager.xml) by comparing max(modification_date) and count(*)
-- against apidb.TuningMgrExternalDependency -- see
-- TuningManager::ExternalTable::getTimestamp. Without the column those three
-- dependencies cannot be tracked.
--
-- Existing rows: localtimestamp is not volatile, so Postgres applies the default
-- without rewriting the table and every pre-existing row is stamped with the
-- time this patch ran. That is the intended reading -- "last known change" --
-- and it makes the first TuningManager pass after the patch see a new
-- max(modification_date) and rebuild the dependent tuning tables once.

ALTER TABLE ApiDB.VariationFeature
  ADD COLUMN IF NOT EXISTS modification_date TIMESTAMP DEFAULT localtimestamp NOT NULL;

ALTER TABLE ApiDB.VariationTranscriptProduct
  ADD COLUMN IF NOT EXISTS modification_date TIMESTAMP DEFAULT localtimestamp NOT NULL;

ALTER TABLE ApiDB.VariationEffect
  ADD COLUMN IF NOT EXISTS modification_date TIMESTAMP DEFAULT localtimestamp NOT NULL;

-- Keeps TuningManager's max(modification_date) off a full scan of these
-- (multi-million-row) tables on every pass.
CREATE INDEX IF NOT EXISTS variationfeature_moddate_ix
  ON ApiDB.VariationFeature (modification_date);
CREATE INDEX IF NOT EXISTS variationtranscriptproduct_md_ix
  ON ApiDB.VariationTranscriptProduct (modification_date);
CREATE INDEX IF NOT EXISTS variationeffect_moddate_ix
  ON ApiDB.VariationEffect (modification_date);

-- No trigger: the column default supplies modification_date for the only write
-- pattern these tables see (delete by external_database_release_id + COPY
-- reload). DEFAULT does not fire on UPDATE -- see the note in
-- createVariationTables.sql if you ever need to update a row in place.
