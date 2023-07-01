{{ config(materialized='view', schema='stg') }}

with listtime_as_date_cte as (
    SELECT *,
        listtime::date as listtime_date
    FROM
        {{ source('tickit_source_tables', 'listing') }}
)

SELECT *, 
    extract(year from listtime_date) as listtime_year, 
    extract(month from listtime_date) as listtime_month,
    extract(day from listtime_date) as listtime_day 
FROM listtime_as_date_cte


