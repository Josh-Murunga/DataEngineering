{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select * from {{ source('staging','fhv_tripdata') }}
  where date(pickup_datetime) between '2019-01-01' and '2019-12-31' 
)

select * from tripdata

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}