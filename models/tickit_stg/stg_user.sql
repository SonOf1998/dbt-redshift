{{ config(materialized='view', schema='stg') }}

SELECT * FROM {{ source('tickit_source_tables', 'user') }}