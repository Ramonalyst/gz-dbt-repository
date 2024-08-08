{{
 dbt_utils.union_relations(
 relations=[ref('stg_raw__adwords'), ref('stg_raw__bing'), ref('stg_raw__criteo'), ref('stg_raw__facebook')]
 )}}