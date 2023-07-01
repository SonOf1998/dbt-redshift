SELECT 
    day 
FROM
    {{ ref('stg_date') }}
WHERE day NOT BETWEEN 1 AND 31