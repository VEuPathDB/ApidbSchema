
create or replace view eda.StudyIdDatasetId as
  select study_stable_id, dataset_id
  from apidbTuning.StudyIdDatasetId
;

grant select on eda.StudyIdDatasetId to public;

create or replace view eda.UnifiedEntityTypeGraph as
  select study_stable_id, parent_stable_id, stable_id, display_name,
         display_name_plural, description, internal_abbrev,
         has_attribute_collections, is_many_to_one_with_parent
  from eda.EntityTypeGraph
;

grant select on eda.UnifiedEntityTypeGraph to public;

-----------------------------------------------------------